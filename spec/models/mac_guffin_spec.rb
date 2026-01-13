require 'rails_helper'

RSpec.describe MacGuffin, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:user) }
  end

  describe "validations" do
    it "is valid with factory defaults" do
      expect(build(:mac_guffin)).to be_valid
    end

    it "requires a name" do
      mac_guffin = build(:mac_guffin, name: nil)
      expect(mac_guffin).not_to be_valid
      expect(mac_guffin.errors[:name]).to be_present
    end

    it "requires a visibility level" do
      mac_guffin = build(:mac_guffin, visibility: nil)
      expect(mac_guffin).not_to be_valid
      expect(mac_guffin.errors[:visibility]).to be_present
    end

    it "requires a user" do
      mac_guffin = build(:mac_guffin, user: nil)
      expect(mac_guffin).not_to be_valid
      expect(mac_guffin.errors[:user]).to be_present
    end
  end

  describe "enums" do
    it "defines all possible visibilities" do
      expect(described_class.visibilities.keys).to match_array(%w[open user admin])
    end
  end

  describe "#visible_to" do
    let(:jake)     { create(:user) }
    let(:santiago) { create(:user) }
    let(:holt)     { create(:user, :admin) }

    let(:crown)  { create(:mac_guffin, visibility: :open,  user: jake) }
    let(:plaque) { create(:mac_guffin, visibility: :user,  user: jake) }
    let(:watch)  { create(:mac_guffin, visibility: :admin, user: holt) }

    it "shows public MacGuffins to anyone" do
      expect(described_class.visible_to(nil)).to include(crown)
      expect(described_class.visible_to(nil)).not_to include(plaque, watch)
    end

    it "shows public and private MacGuffins to any logged-in user" do
      expect(described_class.visible_to(jake)).to include(crown, plaque)
      expect(described_class.visible_to(jake)).not_to include(watch)

      expect(described_class.visible_to(santiago)).to include(crown, plaque)
      expect(described_class.visible_to(santiago)).not_to include(watch)
    end

    it "shows secret MacGuffins to any logged-in admin" do
      expect(described_class.visible_to(holt)).to include(crown, plaque, watch)
    end
  end
end
