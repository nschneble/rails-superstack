# SuperAdmin dashboard for MacGuffins

class SuperAdmin::Demo::MacGuffinDashboard < SuperAdmin::BaseDashboard
  resource Demo::MacGuffin

  collection_attributes :id, :name, :description, :user_id, :visibility
  show_attributes :id, :name, :description, :user_id, :visibility
  form_attributes :description, :name, :user_id, :visibility
end
