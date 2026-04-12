if Rails.env.development?
  namespace :demo do
    get "welcome", to: "welcome#show", as: :welcome
  end
end
