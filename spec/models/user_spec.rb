require 'rails_helper'

RSpec.describe User, type: :model do
  describe "#record_passwordless_login!" do
    let(:one_microsecond) { 0.000001 }

    it "sets email_confirmed_at on first login and updates last_login attributes" do
      user = create(:user)
      request = instance_double(ActionDispatch::Request, remote_ip: "127.0.0.1")

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
      request = instance_double(ActionDispatch::Request, remote_ip: "10.0.0.5")

      freeze_time do
        user.record_passwordless_login!(request)

        user.reload
        expect(user.email_confirmed_at).to be_within(one_microsecond).of(confirmed_at)
        expect(user.last_login_at).to eq(Time.current)
        expect(user.last_login_ip.to_s).to eq("10.0.0.5")
        expect(user.login_count).to eq(6)
      end
    end
  end

  describe "validations" do
    context "when valid" do
      it "with a unique email" do
        user = build(:user)
        expect(user).to be_valid
      end
    end

    context "when invalid" do
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

  describe "#sub_active?" do
    it "returns false with no subscription" do
      user = build(:user)
      expect(user.active_subscription?).to be(false)
    end

    it "returns true with an active subscription" do
      user = create(:user)
      create(:subscription, user:, status: :active)
      expect(user.reload.active_subscription?).to be(true)
    end

    it "returns true with a trialing subscription" do
      user = create(:user)
      create(:subscription, user:, status: :trialing)
      expect(user.reload.active_subscription?).to be(true)
    end

    it "returns false with a canceled subscription" do
      user = create(:user)
      create(:subscription, user:, status: :canceled)
      expect(user.reload.active_subscription?).to be(false)
    end
  end

  describe "#sub_stripe_customer_id" do
    it "returns nil when no subscription exists" do
      user = build(:user)
      expect(user.stripe_customer_id).to be_nil
    end

    it "returns the customer ID from the subscription" do
      user = create(:user)
      create(:subscription, user:, stripe_customer_id: "cus_test123")
      expect(user.stripe_customer_id).to eq("cus_test123")
    end
  end

  describe "roles" do
    it "defaults to regulars users" do
      user = build(:user)
      expect(user.role).to eq("user")
      expect(user).not_to be_admin
    end

    it "enables admin users" do
      user = build(:user, :admin)
      expect(user.role).to eq("admin")
      expect(user).to be_admin
    end
  end
end
