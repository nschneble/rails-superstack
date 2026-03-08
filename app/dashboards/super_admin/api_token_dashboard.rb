class SuperAdmin::ApiTokenDashboard < SuperAdmin::BaseDashboard
  resource ApiToken

  collection_attributes :id,
                        :name,
                        :expires_at,
                        :last_used_at,
                        :revoked_at,
                        :token_digest,
                        :user_id

  show_attributes :id,
                  :name,
                  :expires_at,
                  :last_used_at,
                  :revoked_at,
                  :token_digest,
                  :user_id

  form_attributes :name,
                  :expires_at,
                  :last_used_at,
                  :revoked_at,
                  :token_digest,
                  :user_id
end
