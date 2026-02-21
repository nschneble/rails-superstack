namespace :demo do
  get "notifications", to: "notifications#new", as: :system_notifications
  post "notifications", to: "notifications#create"
end
