namespace :demo do
  resources :mac_guffins, only: [ :index ] do
    resource :like, controller: "mac_guffin_likes", only: [ :create, :destroy ]
  end
end
