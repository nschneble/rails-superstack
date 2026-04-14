require "rails_helper"

RSpec.describe Demo::WelcomeItemDecorator, type: :decorator do
  subject(:decorator) { item.decorate }

  let(:item) do
    Demo::WelcomeItem.new(
      avatar: "trophy",
      description: [ "Hello", { link: "World", to: "https://example.com" } ],
      byline: [ { highlight: "note" }, { hidden: [ "more" ] } ],
      visibility: "all"
    )
  end

  describe "#rendered_description" do
    it "renders plain string segments" do
      expect(decorator.rendered_description).to include("Hello")
    end

    it "renders link segments as anchor tags" do
      expect(decorator.rendered_description).to include("<a")
      expect(decorator.rendered_description).to include("World")
    end

    it "includes turbo data attributes when the link has a method" do
      item = Demo::WelcomeItem.new(
        avatar: "trophy",
        description: [ { link: "Delete", to: "https://example.com", method: "delete" } ],
        byline: [],
        visibility: "all"
      )
      result = item.decorate.rendered_description
      expect(result).to include("turbo-method")
    end
  end

  describe "#rendered_byline" do
    it "renders highlight segments as span tags" do
      expect(decorator.rendered_byline).to include("note")
    end

    it "renders hidden segments wrapped in a span" do
      expect(decorator.rendered_byline).to include("hidden sm:inline")
    end
  end

  describe "#rendered_description with an unrecognized hash key" do
    it "renders nil for hash segments with no recognized key" do
      item = Demo::WelcomeItem.new(
        avatar: "trophy",
        description: [ "Hello", { unknown_key: "ignored" } ],
        byline: [],
        visibility: "all"
      )
      result = item.decorate.rendered_description
      expect(result).to include("Hello")
    end
  end
end
