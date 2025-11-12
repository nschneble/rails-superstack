require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    context "is valid" do
      it "with a unique email" do
        user = build(:user)
        expect(user).to be_valid
      end
    end

    context "is invalid" do
      it "with a nil email" do
        user = build(:user, email: nil)
        expect(user).not_to be_valid
      end

      it "with an empty email" do
        user = build(:user, email: "")
        expect(user).not_to be_valid
      end

      it "with a malformed email" do
        user = build(:user, email: "Hello, world!")
        expect(user).not_to be_valid
      end

      it "with a duplicate email" do
        user = create(:user)
        duplicate = build(:user, email: user.email)

        expect(duplicate).not_to be_valid
        expect(duplicate.errors[:email]).to include("has already been taken")
      end

      it "with a duplicate email with extra whitespace" do
        user = create(:user)
        duplicate = build(:user, email: " #{user.email} ")

        expect(duplicate).not_to be_valid
        expect(duplicate.errors[:email]).to include("has already been taken")
      end

      it "with a duplicate email with different casing" do
        user = create(:user)
        duplicate = build(:user, email: user.email.upcase)

        expect(duplicate).not_to be_valid
        expect(duplicate.errors[:email]).to include("has already been taken")
      end
    end
  end
end
