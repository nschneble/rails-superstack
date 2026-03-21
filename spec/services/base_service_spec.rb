require "rails_helper"

RSpec.describe BaseService do
  describe ".call" do
    it "raises NotImplementedError" do
      expect { described_class.call }.to raise_error(NotImplementedError)
    end
  end

  describe "subclass" do
    let(:subclass) do
      Class.new(BaseService) do
        def call = "result"
      end
    end

    it "does not raise when #call is overridden" do
      expect { subclass.call }.not_to raise_error
    end

    it "delegates .call to #call" do
      expect(subclass.call).to eq("result")
    end
  end
end
