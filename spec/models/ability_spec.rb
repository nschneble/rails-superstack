require 'rails_helper'

RSpec.describe Ability do
  def ability_for(user)
    described_class.new(user)
  end

  let(:jake)     { create(:user) }
  let(:santiago) { create(:user) }
  let(:holt)     { create(:user, :admin) }

  let(:crown)  { create(:mac_guffin, visibility: :open,  user: jake) }
  let(:plaque) { create(:mac_guffin, visibility: :user,  user: jake) }
  let(:watch)  { create(:mac_guffin, visibility: :admin, user: holt) }

  describe "#read" do
    it "allows anyone to view public MacGuffins" do
      ability = ability_for(nil)
      expect(ability.can?(:read, crown)).to be(true)
      expect(ability.can?(:read, plaque)).to be(false)
      expect(ability.can?(:read, watch)).to be(false)
    end

    it "allows logged-in users to view public and private MacGuffins" do
      ability = ability_for(santiago)
      expect(ability.can?(:read, crown)).to be(true)
      expect(ability.can?(:read, plaque)).to be(true)
      expect(ability.can?(:read, watch)).to be(false)
    end

    it "allows logged-in admins to view public, private, and secret MacGuffins" do
      ability = ability_for(holt)
      expect(ability.can?(:read, crown)).to be(true)
      expect(ability.can?(:read, plaque)).to be(true)
      expect(ability.can?(:read, watch)).to be(true)
    end
  end

  describe "#manage" do
    it "disallows anonymous users from managing any MacGuffins" do
      ability = ability_for(nil)
      expect(ability.can?(:manage, crown)).to be(false)
    end

    it "allows logged-in users to manage their own MacGuffins" do
      ability = ability_for(jake)
      expect(ability.can?(:manage, crown)).to be(true)
      expect(ability.can?(:manage, plaque)).to be(true)
    end

    it "disallows logged-in users from managing other user's MacGuffins" do
      ability = ability_for(santiago)
      expect(ability.can?(:manage, crown)).to be(false)
      expect(ability.can?(:manage, plaque)).to be(false)
    end

    it "allows logged-in admins to manage all MacGuffins" do
      ability = ability_for(holt)
      expect(ability.can?(:manage, crown)).to be(true)
      expect(ability.can?(:manage, plaque)).to be(true)
      expect(ability.can?(:manage, watch)).to be(true)
    end
  end
end
