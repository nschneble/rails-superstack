module Demo
  # Renders the CLI command reference guide for the demo terminal page
  class TerminalController < DemoApplicationController
    def show
      @commands = TerminalCommand.all.map(&:decorate)
    end
  end
end
