# Immutable value object representing a CLI command

Demo::TerminalCommand = Data.define(:icon, :name, :code, :description) do
  include Draper::Decoratable
end
