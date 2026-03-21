module Demo
  class MacGuffins::SearchService < BaseService
    PER_PAGE = 4

    def call(ability:, query:, page:, request:)
      searchable_ids = MacGuffin.accessible_by(ability).pluck(:id)
      return ServiceResult.ok(empty_result(page, request)) if searchable_ids.empty?

      pagy, results = MacGuffin.search(
        query,
        "name,description",
        page:,
        per_page: PER_PAGE,
        filter_by: "id:=[#{searchable_ids.join(",")}]",
        sort_by: "name:asc"
      )

      ServiceResult.ok([ pagy_with_request(pagy, request), results ])
    rescue Typesense::Error => error
      Rails.logger.error(error.message)
      ServiceResult.fail(:search_unavailable, empty_result(page, request))
    end

    private

    def empty_result(page, request)
      [
        Pagy::Offset.new(count: 0, page: page.presence || 1, limit: PER_PAGE, request:),
        []
      ]
    end

    def pagy_with_request(pagy, request)
      pagy.tap { |p| p.instance_variable_set(:@request, request) }
    end
  end
end
