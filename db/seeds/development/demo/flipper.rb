user  = User.find_by!(email: "user@superstack.dev")
admin = User.find_by!(email: "admin@superstack.dev")

Flipper.enable_actor(:secrets, user)
Flipper.enable_actor(:secrets, admin)
