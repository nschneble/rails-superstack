require "rails_helper"

RSpec.describe Demo::MacGuffinLikes::DestroyService, type: :service do
  subject(:result) { described_class.call(user:, mac_guffin:, ability: Ability.new(user)) }

  let(:user) { create(:user) }
  let(:mac_guffin) { create(:mac_guffin, visibility: :open) }

  describe "when a like exists" do
    before { create(:mac_guffin_like, user:, mac_guffin:) }

    it "destroys the like" do
      like_id = Demo::MacGuffinLike.find_by(user:, mac_guffin:).id
      result
      expect(Demo::MacGuffinLike.exists?(like_id)).to be false
    end

    it "returns a successful result" do
      expect(result).to be_success
    end
  end

  describe "when no like exists (idempotent)" do
    it "does not raise" do
      expect { result }.not_to raise_error
    end

    it "returns a successful result" do
      expect(result).to be_success
    end
  end
end
