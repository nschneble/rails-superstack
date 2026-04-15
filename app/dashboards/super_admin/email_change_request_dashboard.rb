module SuperAdmin
  # SuperAdmin dashboard for email change requests
  class EmailChangeRequestDashboard < BaseDashboard
    # Attributes shown in the table view
    def collection_attributes
      %i[id expires_at new_email token user_id]
    end

    # Attributes shown in the detail view
    def show_attributes
      %i[id expires_at new_email token user_id]
    end

    # Attributes shown in the form
    def form_attributes
      %i[expires_at new_email token user_id]
    end
  end
end
