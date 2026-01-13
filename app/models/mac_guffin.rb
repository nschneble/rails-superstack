class MacGuffin < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :visibility, presence: true
  validates :user, presence: true

  enum :visibility, { open: 0, user: 1, admin: 2 }

  scope :visible_to, ->(user) do
    if user&.admin?
      all
    elsif user&.persisted?
      where(visibility: [ :open, :user ])
    else
      where(visibility: :open)
    end
  end
end
