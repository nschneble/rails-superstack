require "rails_helper"

RSpec.describe Demo::MacGuffinLike, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:mac_guffin).class_name("Demo::MacGuffin") }
  end

  describe "validations" do
    it "is valid with factory defaults" do
      expect(build(:mac_guffin_like)).to be_valid
    end

    it "does not allow duplicate likes per user and MacGuffin" do
      like = create(:mac_guffin_like)
      duplicate = build(:mac_guffin_like, user: like.user, mac_guffin: like.mac_guffin)

      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:user_id]).to include("has already been taken")
    end

    it "does not allow users to like their own MacGuffins" do
      owner = create(:user)
      mac_guffin = create(:mac_guffin, user: owner)
      like = build(:mac_guffin_like, user: owner, mac_guffin: mac_guffin)

      expect(like).not_to be_valid
      expect(like.errors[:user]).to include("can't like your own MacGuffin")
    end
  end
end
