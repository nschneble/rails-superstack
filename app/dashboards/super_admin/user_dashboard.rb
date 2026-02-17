# frozen_string_literal: true

class SuperAdmin::UserDashboard < SuperAdmin::BaseDashboard
  resource User
  collection_attributes :id, :email, :email_confirmed_at, :last_login_at, :last_login_ip, :login_count, :role
  show_attributes :id, :email, :email_confirmed_at, :last_login_at, :last_login_ip, :login_count, :role
  form_attributes :email, :email_confirmed_at, :last_login_at, :last_login_ip, :login_count, :role
end
