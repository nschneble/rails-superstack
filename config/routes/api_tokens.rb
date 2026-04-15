# provisions API tokens
namespace :settings do
  post   "api_token",     to: "create_api_tokens#create",  as: :create_api_token
  delete "api_token/:id", to: "revoke_api_tokens#destroy", as: :revoke_api_token
end
