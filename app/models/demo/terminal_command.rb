class Demo::TerminalCommand < ApplicationRecord
  include Tableless

  attribute :code, :string
  attribute :icon, :string
  attribute :name, :string
  attribute :text, :string

  validates :code, presence: true
  validates :icon, presence: true
  validates :name, presence: true
  validates :text, presence: true

  def html_text
    text.html_safe
  end
end
