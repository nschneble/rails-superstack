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

    it "renders nil for hash segments with no recognized key" do
      command = Demo::TerminalCommand.new(
        icon: "terminal", name: "test", code: "bin/test",
        description: [ "Run", { unknown_key: "ignored" } ]
      )
      result = command.decorate.rendered_description
      expect(result).to include("Run")
    end

    it "renders nil for non-string, non-hash segments" do
      command = Demo::TerminalCommand.new(
        icon: "terminal", name: "test", code: "bin/test",
        description: [ "Run", 42 ]
      )
      result = command.decorate.rendered_description
      expect(result).to include("Run")
    end
  end
end
