class Demo::MacGuffin < ApplicationRecord
  include Indexable
  include Typesense

  typesense enqueue: :index_async do
    attributes :name, :description
    default_sorting_field "name"

    predefined_fields [
      {
        name: "name",
        type: "string",
        sort: true
      },
      {
        name: "description",
        type: "string",
        optional: true
      }
    ]
  end

  belongs_to :user
  has_many :likes, class_name: "Demo::MacGuffinLike", dependent: :destroy
  has_many :liked_by_users, through: :likes, source: :user
  has_many :noticed_events, as: :record, dependent: :destroy, class_name: "Noticed::Event"
  has_many :notifications, through: :noticed_events, class_name: "Noticed::Notification"

  validates :name, presence: true
  validates :visibility, presence: true
  validates :user, presence: true

  enum :visibility, { open: 0, user: 1, admin: 2 }

  def pretty_visibility
    return "Anyone" if visibility == "open"
    visibility.pluralize
  end

  def to_s
    name
  end
end
