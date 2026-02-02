module Demo
  class MacGuffin < ApplicationRecord
    belongs_to :user

    validates :name, presence: true
    validates :visibility, presence: true
    validates :user, presence: true

    enum :visibility, { open: 0, user: 1, admin: 2 }
  end
end
