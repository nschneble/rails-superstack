module Demo
  # Searches MacGuffins via Typesense with filtering and pagination
  class MacGuffins::SearchService < BaseService
    PER_PAGE = 4

    # :reek:LongParameterList — distinct search context inputs
    def call(ability:, query:, page:, request:)
      searchable_ids = MacGuffin.accessible_by(ability).pluck(:id)
      return empty_result(:ok, page:, request:) if searchable_ids.empty?

      pagy, results = search_mac_guffins(searchable_ids:, query:, page:)
      ServiceResult.ok([ pagy_with_request(pagy, request), results ])
    rescue Typesense::Error => error
      Rails.logger.error(error.message)
      empty_result(:fail, :search_unavailable, page:, request:)
    end

    private

    def empty_result(method, error = nil, page:, request:)
      page = page.presence || 1
      payload = [ Pagy::Offset.new(count: 0, page:, limit: PER_PAGE, request:), [] ]

      ServiceResult.new(success?: method == :ok, payload:, error:)
    end

    def search_mac_guffins(searchable_ids:, query:, page:)
      MacGuffin.search(
        query,
        "name,description",
        page:,
        per_page: PER_PAGE,
        filter_by: "id:=[#{searchable_ids.join(",")}]",
        sort_by: "name:asc"
      )
    end

    def pagy_with_request(pagy, request)
      pagy.tap { it.instance_variable_set(:@request, request) }
    end
  end
end
