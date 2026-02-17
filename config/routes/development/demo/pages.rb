namespace :demo do
  get "terminal", to: "pages#terminal", as: :terminal
  get "welcome",  to: "pages#welcome",  as: :welcome
end
