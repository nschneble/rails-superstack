class Demo::MacGuffinsController < ApplicationController
  MAC_GUFFINS_PER_PAGE = 4

  layout "demo/moxie"

  def index
    @pagy, @mac_guffins = search_for_mac_guffins
    set_like_data
    return unless turbo_frame_request?

    render partial: "search"
  end

  private

  def search_for_mac_guffins
    @search_unavailable = false

    searchable_ids = Demo::MacGuffin.accessible_by(current_ability).pluck(:id)
    return no_mac_guffins_here if searchable_ids.empty?

    pagy, results = Demo::MacGuffin.search(
      @query,
      "name,description",
      page: params[:page],
      per_page: MAC_GUFFINS_PER_PAGE,
      filter_by: "id:=[#{searchable_ids.join(',')}]",
      sort_by: "name:asc"
    )
    [ pagy_with_request(pagy), results ]
  rescue Typesense::Error => error
    Rails.logger.error(error.message)

    @search_unavailable = true
    no_mac_guffins_here
  end

  def no_mac_guffins_here
    [
      Pagy::Offset.new(
        count: 0,
        page: params[:page].presence || 1,
        limit: MAC_GUFFINS_PER_PAGE,
        request: request
      ),
      []
    ]
  end

  def pagy_with_request(pagy)
    pagy.tap { |p| p.instance_variable_set(:@request, request) }
  end

  def set_like_data
    @liked_mac_guffin_ids = []
    @mac_guffin_like_counts = {}

    mac_guffin_ids = @mac_guffins.map(&:id)
    return if mac_guffin_ids.empty?

    @mac_guffin_like_counts = Demo::MacGuffinLike.where(mac_guffin_id: mac_guffin_ids).group(:mac_guffin_id).count
    return unless current_user

    @liked_mac_guffin_ids = current_user.mac_guffin_likes.where(mac_guffin_id: mac_guffin_ids).pluck(:mac_guffin_id)
  end
end
