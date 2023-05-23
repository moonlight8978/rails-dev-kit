class LoginForm < DevKit::Form::Validator
  params do
    required(:email).filled(:string)
    required(:password).filled(:string)
    required(:password_confirmation).filled(:string)
  end

  rule(:email) do
    key.failure("is invalid") unless value == "test@example.com"
  end

  rule(:password_confirmation) do
    key.failure("must match password") unless value == values[:password]
  end
end

describe "DevKit::Form::Validator" do
  let(:form) { LoginForm.new }

  describe "#valid?" do
    subject { form.tap { |f| f.validate(**login_attrs) } }

    context "when params are valid" do
      let(:login_attrs) { { email: "test@example.com", password: "123", password_confirmation: "123" } }

      it { is_expected.to be_valid }
    end

    context "when email is invalid" do
      let(:login_attrs) { { email: "hello", password: "123", password_confirmation: "123" } }

      it { is_expected.to be_invalid }
    end

    context "when passwords are not match" do
      let(:login_attrs) { { email: "test@example.com", password: "1", password_confirmation: "123" } }

      it { is_expected.to be_invalid }
    end
  end

  describe "#validate!" do
    context "when model is valid" do
      let(:login_attrs) { { email: "test@example.com", password: "123", password_confirmation: "123" } }

      it "does not raise error" do
        expect { form.validate!(**login_attrs) }.not_to raise_error
      end

      it "apply coerced values" do
        form.apply(**login_attrs) do |values|
          expect(values[:email]).to eq("test@example.com")
        end
      end
    end

    context "when model is valid" do
      let(:login_attrs) { { email: "invalid", password: "123", password_confirmation: "123" } }

      it "raises error, and adapt to active record error" do
        begin
          form.validate!(**login_attrs)
        rescue ActiveRecord::RecordInvalid => e
          expect(e.record.errors.full_messages).to eq(["email is invalid"])
        end
      end
    end
  end
end
