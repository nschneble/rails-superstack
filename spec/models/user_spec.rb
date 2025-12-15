require 'rails_helper'

RSpec.describe User, type: :model do
  describe "#record_passwordless_login!" do
    let(:microsecond_precision) { 6 }

    it "sets email_confirmed_at on first login and updates last_login attributes" do
      user = create(:user)
      request = instance_double("ActionDispatch::Request", remote_ip: "127.0.0.1")

      freeze_time do
        user.record_passwordless_login!(request)

        expect(user.reload.email_confirmed_at).to eq(Time.current)
        expect(user.last_login_at).to eq(Time.current)
        expect(user.last_login_ip.to_s).to eq("127.0.0.1")
        expect(user.login_count).to eq(1)
      end
    end

    it "does not change email_confirmed_at on subsequent logins" do
      confirmed_at = 2.days.ago
      user = create(:user, email_confirmed_at: confirmed_at, login_count: 5)
      request = instance_double("ActionDispatch::Request", remote_ip: "10.0.0.5")

      freeze_time do
        user.record_passwordless_login!(request)

        user.reload
        expect(user.email_confirmed_at).to eq(confirmed_at.round(microsecond_precision))
        expect(user.last_login_at).to eq(Time.current)
        expect(user.last_login_ip.to_s).to eq("10.0.0.5")
        expect(user.login_count).to eq(6)
      end
    end
  end

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
