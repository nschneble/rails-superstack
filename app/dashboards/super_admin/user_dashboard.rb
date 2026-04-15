module SuperAdmin
  # SuperAdmin dashboard for users
  class UserDashboard < BaseDashboard
    # Attributes shown in the table view
    def collection_attributes
      %i[id email email_confirmed_at last_login_at last_login_ip login_count role]
    end

    # Attributes shown in the detail view
    def show_attributes
      %i[id email email_confirmed_at last_login_at last_login_ip login_count role]
    end

    # Attributes shown in the form
    def form_attributes
      %i[email email_confirmed_at last_login_at last_login_ip login_count role]
    end
  end
end
