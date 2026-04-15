module SuperAdmin
  # SuperAdmin dashboard for MacGuffin likes
  class Demo::MacGuffinLikeDashboard < BaseDashboard
    # Attributes shown in the table view
    def collection_attributes
      %i[id mac_guffin_id user_id]
    end

    # Attributes shown in the detail view
    def show_attributes
      %i[id mac_guffin_id user_id]
    end

    # Attributes shown in the form
    def form_attributes
      %i[mac_guffin_id user_id]
    end
  end
end
