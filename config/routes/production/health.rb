# returns 200 if the app boots with no exceptions
get "up" => "rails/health#show", as: :rails_health_check
