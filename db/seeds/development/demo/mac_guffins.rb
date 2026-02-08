Demo::MacGuffin.find_or_create_by!(
  name: "Unobtainium",
  description: "An ideal material that's impractically difficult or impossible to obtain.",
  visibility: :open,
  user: User.find_by!(email: "user@superstack.dev")
)

Demo::MacGuffin.find_or_create_by!(
  name: "Letters of Transit",
  description: "What you need to get out of Casablanca.",
  visibility: :user,
  user: User.find_by!(email: "user@superstack.dev")
)

Demo::MacGuffin.find_or_create_by!(
  name: "The Infinity Stones",
  description: "How else will you reshape the universe?",
  visibility: :admin,
  user: User.find_by!(email: "admin@superstack.dev")
)
