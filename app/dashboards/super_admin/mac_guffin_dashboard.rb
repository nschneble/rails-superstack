# frozen_string_literal: true

module SuperAdmin
  class MacGuffinDashboard < SuperAdmin::BaseDashboard
    resource MacGuffin
    collection_attributes :id, :name, :description, :user_id, :visibility
    show_attributes :id, :name, :description, :user_id, :visibility
    form_attributes :description, :name, :user_id, :visibility
  end
end
