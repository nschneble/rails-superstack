namespace :demo do
  get "api", to: "pages#api", as: :api
  get "terminal", to: "pages#terminal", as: :terminal
  get "welcome", to: "pages#welcome", as: :welcome
end
