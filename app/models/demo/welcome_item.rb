class Demo::WelcomeItem < ApplicationRecord
  include Tableless

  attribute :avatar, :string
  attribute :header, :string
  attribute :byline, :string
  attribute :hidden, :boolean, default: false

  validates :avatar, presence: true
  validates :header, presence: true
  validates :byline, presence: true

  def html_header
    header.html_safe
  end

  def html_byline
    byline.html_safe
  end
end
