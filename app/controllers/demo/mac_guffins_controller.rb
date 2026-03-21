module Demo
  class MacGuffinsController < ApplicationController
    layout "demo/moxie"

    def index
      result = MacGuffins::SearchService.call(ability: current_ability, query: @query, page: params[:page], request:)

      @pagy, @mac_guffins = result.payload
      @search_unavailable = result.failure?
      return unless turbo_frame_request?

      render partial: "search"
    end
  end
end
