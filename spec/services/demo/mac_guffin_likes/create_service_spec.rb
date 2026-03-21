require "rails_helper"

RSpec.describe Demo::MacGuffinLikes::CreateService, type: :service do
  subject(:result) { described_class.call(user:, mac_guffin:, ability: Ability.new(user)) }

  let(:owner) { create(:user) }
  let(:user) { create(:user) }
  let(:mac_guffin) { create(:mac_guffin, user: owner, visibility: :open) }

  describe "success" do
    it "returns a successful result" do
      expect(result).to be_success
    end

    it "returns the like as payload" do
      expect(result.payload).to be_a(Demo::MacGuffinLike)
    end

    it "persists the like" do
      expect { result }.to change(Demo::MacGuffinLike, :count).by(1)
    end

    it "delivers a Demo::NewMacGuffinLikeNotifier" do
      expect(Demo::NewMacGuffinLikeNotifier).to receive(:with)
        .with(record: mac_guffin, actor: user)
        .and_call_original
      result
    end
  end

  describe "failure: user likes their own mac_guffin" do
    subject(:result) { described_class.call(user: owner, mac_guffin:, ability: Ability.new(owner)) }

    it "returns a failure result" do
      expect(result).to be_failure
    end

    it "does not persist the like" do
      expect { result }.not_to change(Demo::MacGuffinLike, :count)
    end

    it "does not deliver a notification" do
      expect(Demo::NewMacGuffinLikeNotifier).not_to receive(:with)
      result
    end
  end

  describe "idempotency: duplicate like" do
    before { create(:mac_guffin_like, user:, mac_guffin:) }

    it "returns success (find_or_initialize_by re-uses the existing like)" do
      expect(result).to be_success
    end

    it "does not create a second like record" do
      expect { result }.not_to change(Demo::MacGuffinLike, :count)
    end
  end
end
