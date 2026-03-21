class SuperAdmin::Demo::MacGuffinLikeDashboard < SuperAdmin::BaseDashboard
  resource Demo::MacGuffinLike

  collection_attributes :id, :mac_guffin_id, :user_id
  show_attributes :id, :mac_guffin_id, :user_id
  form_attributes :mac_guffin_id, :user_id
end
