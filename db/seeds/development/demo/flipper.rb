user  = User.find_or_create_by!(email: "user@superstack.dev", role: :user)
admin = User.find_or_create_by!(email: "admin@superstack.dev", role: :admin)

Flipper.enable_actor(:secrets, user)
Flipper.enable_actor(:secrets, admin)
