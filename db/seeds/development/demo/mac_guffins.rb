user  = User.find_by!(email: "user@superstack.dev")
admin = User.find_by!(email: "admin@superstack.dev")

Demo::MacGuffin.find_or_create_by!(
  name: "Unobtainium",
  description: "An ideal material that's impractically difficult to obtain.",
  visibility: :open,
  user:
)

Demo::MacGuffin.find_or_create_by!(
  name: "Red Herring",
  description: "Something that misleads or distracts from an important question.",
  visibility: :open,
  user:
)

Demo::MacGuffin.find_or_create_by!(
  name: "The Holy Grail",
  description: "A treasure that serves as an important motif in Arthurian literature.",
  visibility: :open,
  user:
)

Demo::MacGuffin.find_or_create_by!(
  name: "The Maltese Falcon",
  description: "A black statuette of unknown but substantial value.",
  visibility: :open,
  user:
)

Demo::MacGuffin.find_or_create_by!(
  name: "Alien Space Bats",
  description: "A neologism for plot devices used in alternate history to mean an implausible point of divergence.",
  visibility: :open,
  user:
)

Demo::MacGuffin.find_or_create_by!(
  name: "Letters of Transit",
  description: "What you need to get out of Casablanca.",
  visibility: :user,
  user:
)

Demo::MacGuffin.find_or_create_by!(
  name: "Big Dumb Object",
  description: "Any mysterious object in a story which generates a sense of wonder by its mere existence.",
  visibility: :user,
  user:
)

Demo::MacGuffin.find_or_create_by!(
  name: "The Infinity Stones",
  description: "How else will you reshape the universe?",
  visibility: :admin,
  user: admin
)

Demo::MacGuffin.find_or_create_by!(
  name: "Ark of the Covenant",
  description: "A religious storage chest and relic held to be the most sacred object by the Israelites.",
  visibility: :admin,
  user: admin
)
