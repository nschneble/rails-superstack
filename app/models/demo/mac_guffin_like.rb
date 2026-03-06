class Demo::MacGuffinLike < ApplicationRecord
  belongs_to :user
  belongs_to :mac_guffin, class_name: "Demo::MacGuffin"

  validates :user_id, uniqueness: { scope: :mac_guffin_id }
  validate :no_self_promotion

  private

  def no_self_promotion
    return if user.blank? || mac_guffin.blank?
    return if user != mac_guffin.user

    errors.add :user, I18n.t("validations.mac_guffins.no_self_promotion")
  end
end
