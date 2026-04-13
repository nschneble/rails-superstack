require "rails_helper"

RSpec.describe Demo::TerminalCommandDecorator, type: :decorator do
  subject(:decorator) { command.decorate }

  let(:command) do
    Demo::TerminalCommand.new(
      icon: "terminal",
      name: "rspec",
      code: "bin/rspec",
      description: [ "Run", { link: "RSpec", to: "https://rspec.info/" }, { hidden: [ "tests" ] } ]
    )
  end

  describe "#rendered_description" do
    it "renders plain string segments" do
      expect(decorator.rendered_description).to include("Run")
    end

    it "renders link segments as anchor tags" do
      expect(decorator.rendered_description).to include("<a")
      expect(decorator.rendered_description).to include("RSpec")
    end

    it "renders hidden segments wrapped in a span" do
      expect(decorator.rendered_description).to include("hidden sm:inline")
    end
  end
end
