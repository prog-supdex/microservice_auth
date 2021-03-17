class Roda
  module RodaPlugins
    module PaginationLinks
      module RequestMethods
        def pagination_links(dataset)
          return {} if dataset.pagination_record_count.zero?

          links = {
            first: pagination_link(page: 1),
            last: pagination_link(page: dataset.page_count)
          }

          links[:next] = pagination_link(page: dataset.next_page) if dataset.next_page.present?
          links[:prev] = pagination_link(page: dataset.prev_page) if dataset.prev_page.present?

          links
        end

        private

        def pagination_link(page:)
          qs = self.params.merge('page' => page).to_query
          [self.path, qs].join('?')
        end
      end
    end

    register_plugin :pagination_links, PaginationLinks
  end
end
