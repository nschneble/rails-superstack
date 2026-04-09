# SuperAdmin dashboard for email change requests

class SuperAdmin::EmailChangeRequestDashboard < SuperAdmin::BaseDashboard
  resource EmailChangeRequest

  collection_attributes :id, :expires_at, :new_email, :token, :user_id
  show_attributes :id, :expires_at, :new_email, :token, :user_id
  form_attributes :expires_at, :new_email, :token, :user_id
end
