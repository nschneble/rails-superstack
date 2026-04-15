module SuperAdmin
  # SuperAdmin dashboard for API tokens
  class ApiTokenDashboard < BaseDashboard
    # Attributes shown in the table view
    def collection_attributes
      %i[id name expires_at last_used_at revoked_at token_digest user_id]
    end

    # Attributes shown in the detail view
    def show_attributes
      %i[id name expires_at last_used_at revoked_at token_digest user_id]
    end

    # Attributes shown in the form
    def form_attributes
      %i[name expires_at last_used_at revoked_at token_digest user_id]
    end
  end
end
