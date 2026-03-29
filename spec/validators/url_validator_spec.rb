require "rails_helper"

RSpec.describe URLValidator, type: :model do
  subject(:record) { model_class.new }

  let(:model_class) do
    Class.new do
      include ActiveModel::Validations
      attr_accessor :website
      validates :website, url: true
      def self.name = "AnonymousModel"
    end
  end


  describe "without a host constraint" do
    it "is valid for a well-formed https URL" do
      record.website = "https://example.com"
      expect(record).to be_valid
    end

    it "is invalid for nil" do
      record.website = nil
      expect(record).not_to be_valid
      expect(record.errors[:website]).to include("is not a valid HTTPS url")
    end

    it "is invalid for an http URL" do
      record.website = "http://example.com"
      expect(record).not_to be_valid
    end

    it "is invalid for a non-URL string" do
      record.website = "not a url"
      expect(record).not_to be_valid
    end
  end

  describe "with a host constraint" do
    let(:model_class) do
      Class.new do
        include ActiveModel::Validations
        attr_accessor :website
        validates :website, url: { host: /\Aexample\.com\z/ }
        def self.name = "AnonymousModelWithHost"
      end
    end

    it "is valid when the host matches" do
      record.website = "https://example.com/path"
      expect(record).to be_valid
    end

    it "is invalid when the host does not match" do
      record.website = "https://evil.com"
      expect(record).not_to be_valid
    end
  end

  describe "with a custom message" do
    subject(:record) { model_class.new }

    let(:model_class) do
      Class.new do
        include ActiveModel::Validations
        attr_accessor :link
        validates :link, url: { message: "must be a secure URL" }
        def self.name = "AnonymousModelCustomMsg"
      end
    end


    it "uses the custom message when validation fails" do
      record.link = "http://example.com"
      record.valid?
      expect(record.errors[:link]).to include("must be a secure URL")
    end
  end
end
