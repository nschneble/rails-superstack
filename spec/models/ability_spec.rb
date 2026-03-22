require "rails_helper"

RSpec.describe Ability do
  it "initializes without errors" do
    expect { described_class.new(nil) }.not_to raise_error
  end

  describe "Subscription rules" do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let!(:subscription) { create(:subscription, user:) }

    it "lets users manage their own subscription" do
      ability = described_class.new(user)
      expect(ability.can?(:manage, subscription)).to be(true)
    end

    it "does not let users manage another user's subscription" do
      ability = described_class.new(other_user)
      expect(ability.can?(:manage, subscription)).to be(false)
    end

    it "lets active Pro subscribers access pro features" do
      create(:subscription, :pro_monthly, user: other_user, status: :active)
      ability = described_class.new(other_user.reload)
      expect(ability.can?(:access, :pro_features)).to be(true)
    end

    it "does not let users on the free plan access pro features" do
      ability = described_class.new(user)
      expect(ability.can?(:access, :pro_features)).to be(false)
    end

    it "does not let Pro subscribers with canceled status access pro features" do
      create(:subscription, :pro_monthly, :canceled, user: other_user)
      ability = described_class.new(other_user.reload)
      expect(ability.can?(:access, :pro_features)).to be(false)
    end

    it "lets admins manage any subscription" do
      admin = create(:user, :admin)
      ability = described_class.new(admin)
      expect(ability.can?(:manage, subscription)).to be(true)
    end
  end

  describe "MacGuffin rules" do
    let!(:open_mac_guffin) { create(:mac_guffin, visibility: :open) }
    let!(:user_mac_guffin) { create(:mac_guffin, :user) }
    let!(:admin_mac_guffin) { create(:mac_guffin, :admin) }

    it "lets guests read open MacGuffins only" do
      ability = described_class.new(nil)
      visible_ids = Demo::MacGuffin.accessible_by(ability).pluck(:id)

      expect(visible_ids).to contain_exactly(open_mac_guffin.id)
    end

    it "lets users read open and user MacGuffins" do
      ability = described_class.new(create(:user))
      visible_ids = Demo::MacGuffin.accessible_by(ability).pluck(:id)

      expect(visible_ids).to include(open_mac_guffin.id, user_mac_guffin.id)
      expect(visible_ids).not_to include(admin_mac_guffin.id)
    end

    it "lets users manage their own MacGuffins only" do
      owner = create(:user)
      own_mac_guffin = create(:mac_guffin, user: owner)
      other_mac_guffin = create(:mac_guffin)
      ability = described_class.new(owner)

      expect(ability.can?(:manage, own_mac_guffin)).to be(true)
      expect(ability.can?(:manage, other_mac_guffin)).to be(false)
    end

    it "lets admins manage any MacGuffin and read admin MacGuffins" do
      ability = described_class.new(create(:user, :admin))
      visible_ids = Demo::MacGuffin.accessible_by(ability).pluck(:id)

      expect(visible_ids).to include(admin_mac_guffin.id)
      expect(ability.can?(:manage, open_mac_guffin)).to be(true)
      expect(ability.can?(:manage, user_mac_guffin)).to be(true)
      expect(ability.can?(:manage, admin_mac_guffin)).to be(true)
    end
  end
end
