require "rails_helper"

RSpec.describe Pom::SubscriptionBadgeComponent, type: :component do
  describe "#default_options" do
    context "when pro is false (default)" do
      subject(:component) { described_class.new }

      it "includes the free badge class" do
        options = component.default_options
        expect(options[:class]).to include("bg-slate-500")
        expect(options[:class]).to include("text-white")
      end
    end

    context "when pro is true" do
      subject(:component) { described_class.new(pro: true) }

      it "includes the pro badge class" do
        options = component.default_options
        expect(options[:class]).to include("bg-lime-500")
        expect(options[:class]).to include("text-white")
      end
    end
  end
end
