namespace :demo do
  get "alert",  to: "flash#alert",  as: :alert
  get "notice", to: "flash#notice", as: :notice
end
