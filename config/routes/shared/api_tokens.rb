# provisions API tokens
namespace :settings do
  post   "api_token",     to: "api_tokens#create",  as: :create_api_token
  delete "api_token/:id", to: "api_tokens#destroy", as: :delete_api_token
end
