if Rails.env.development?
  namespace :demo do
    get "terminal", to: "terminal#show", as: :terminal
  end
end
