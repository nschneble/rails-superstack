require 'rails_helper'

RSpec.describe Demo::MacGuffin, type: :model do
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
end
