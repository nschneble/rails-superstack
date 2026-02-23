class Demo::MacGuffinLike < ApplicationRecord
  self.table_name = "demo_mac_guffin_likes"

  belongs_to :user
  belongs_to :mac_guffin, class_name: "Demo::MacGuffin"

  validates :user_id, uniqueness: { scope: :mac_guffin_id }
  validate :cannot_like_own_mac_guffin

  private

  def cannot_like_own_mac_guffin
    return if user.blank? || mac_guffin.blank?
    return if user != mac_guffin.user

    errors.add(:user, "can't like your own MacGuffin")
  end
end
