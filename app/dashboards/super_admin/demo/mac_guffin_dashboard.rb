module SuperAdmin
  # SuperAdmin dashboard for MacGuffins
  class Demo::MacGuffinDashboard < BaseDashboard
    # Attributes shown in the table view
    def collection_attributes
      %i[id name description user_id visibility]
    end

    # Attributes shown in the detail view
    def show_attributes
      %i[id name description user_id visibility]
    end

    # Attributes shown in the form
    def form_attributes
      %i[name description user_id visibility]
    end
  end
end
