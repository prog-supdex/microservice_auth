module Ads
  class CreateService
    prepend BasicService

    option :ad do
      option :title
      option :description
      option :city
    end

    option :user_id

    def call
      @ad = ::Ad.new(@ad.to_h)
      @ad.user_id = @user_id

      if @ad.valid?
        @ad.save

        GeocodingJob.perform_later(@ad.values)
      else
        fail!(@ad.errors)
      end
    end
  end
end
