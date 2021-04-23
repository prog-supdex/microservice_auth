module Subscriptions
  class Authentication
    attr_reader :queue, :channel

    def initialize
      @channel = RabbitMq.channel
      @queue = channel.queue('authentication')
      @reply_queue = channel.queue('auth_ads')
    end

    def start
      queue.subscribe do |_delivery_info, properties, payload|
        extracted_token = JwtEncoder.decode(payload)
        result = Auth::FetchUserService.call(uuid: extracted_token['uuid'])

        user_id = result.user.id if result.success?

        channel.default_exchange.publish(
          user_id.to_s,
          app_id: Settings.app.name,
          routing_key: properties.reply_to,
          correlation_id: properties.correlation_id,
          headers: {
            request_id: Thread.current[:request_id]
          }
        )
      end
    end
  end
end

Subscriptions::Authentication.new.start
