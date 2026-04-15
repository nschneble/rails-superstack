require "rails_helper"

RSpec.describe Demo::Themes::ThemePurchase, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:user) }
  end

  describe "validations" do
    subject { build(:demo_theme_purchase) }

    it { is_expected.to validate_presence_of(:theme_key) }
    it { is_expected.to validate_inclusion_of(:theme_key).in_array(Demo::Themes::Theme.purchasable.map(&:key)) }
  end

  describe "#theme_name" do
    it "returns the human-readable name for midnight_galaxy" do
      purchase = build(:demo_theme_purchase, theme_key: "midnight_galaxy")
      expect(purchase.theme_name).to eq("Midnight Galaxy")
    end

    it "returns the human-readable name for crimson_tide" do
      purchase = build(:demo_theme_purchase, theme_key: "crimson_tide")
      expect(purchase.theme_name).to eq("Crimson Tide")
    end
  end

  describe "#theme_description" do
    it "returns the description for a valid theme" do
      purchase = build(:demo_theme_purchase, theme_key: "midnight_galaxy")
      expect(purchase.theme_description).to be_present
    end
  end

  describe "#price_cents" do
    it "returns the correct price for midnight_galaxy" do
      purchase = build(:demo_theme_purchase, theme_key: "midnight_galaxy")
      expect(purchase.theme_price_cents).to eq(1499)
    end

    it "returns the correct price for forest_canopy" do
      purchase = build(:demo_theme_purchase, theme_key: "forest_canopy")
      expect(purchase.theme_price_cents).to eq(499)
    end
  end

  describe "status enum" do
    it "defaults to pending" do
      purchase = create(:demo_theme_purchase)
      expect(purchase.status).to eq("pending")
    end

    it "can be completed" do
      purchase = create(:demo_theme_purchase, :completed)
      expect(purchase.status).to eq("completed")
    end
  end

  describe "#theme" do
    it "returns the decorated theme for a valid theme_key" do
      purchase = build(:demo_theme_purchase, theme_key: "midnight_galaxy")
      expect(purchase.theme).to be_present
    end

    it "returns nil when the theme cannot be found" do
      purchase = build(:demo_theme_purchase, theme_key: "midnight_galaxy")
      allow(Demo::Themes::Theme).to receive(:find).with("midnight_galaxy").and_return(nil)
      expect(purchase.theme).to be_nil
    end

    context "when theme is nil" do
      before do
        allow(Demo::Themes::Theme).to receive(:find).and_return(nil)
      end

      it "returns nil for theme_name" do
        purchase = build(:demo_theme_purchase, theme_key: "midnight_galaxy")
        expect(purchase.theme_name).to be_nil
      end

      it "returns nil for theme_price_cents" do
        purchase = build(:demo_theme_purchase, theme_key: "midnight_galaxy")
        expect(purchase.theme_price_cents).to be_nil
      end

      it "returns nil for theme_description" do
        purchase = build(:demo_theme_purchase, theme_key: "midnight_galaxy")
        expect(purchase.theme_description).to be_nil
      end
    end
  end
end
