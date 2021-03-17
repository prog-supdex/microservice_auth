class AdRoutes < Application
  use Rack::CommonLogger, Logger.new($stdout)

  plugin :pagination_links

  route do |r|
    r.on 'ads/v1' do
      r.is do
        r.get(true) do
          page = r.params[:page].presence || 1
          ads = Ad.reverse_order(:updated_at)
          ads = ads.paginate(page.to_i, Settings.pagination.page_size)

          serializer = AdSerializer.new(ads.all, links: r.pagination_links(ads))
          serializer.serializable_hash
        end

        r.post do
          params = JSON.parse(r.body.read)
          ad_params = r.validate_with!(validation: AdParamsContract, params: params)

          result = Ads::CreateService.call(ad: ad_params[:ad], user_id: params['user_id'])

          if result.success?
            response.status = :created

            AdSerializer.new(result.ad).serializable_hash
          else
            response.status = :unprocessable_entity
            error_response(result.ad)
          end
        end
      end
    end
  end
end
