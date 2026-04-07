# Immutable value object representing a CLI command

module Demo
  TerminalCommand = Data.define(:icon, :name, :code, :description) do
    include Draper::Decoratable
    include Serializable

    json_source "lib/data/demo/terminal_commands.json"
  end
end
