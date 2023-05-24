describe DevKit::Cryptographic::SymmetricSigner do
  let(:signer) { described_class.new(secret: "7403ecead4035e881b9cdef31fb975bc868d869d3379378d68ef5760456e74756d67074efc80e584d7967365b5afb9bff23ebd104d541e5fbd3de30d0159b8c5") }

  around do |example|
    travel_to(Time.zone.local(2023, 5, 24, 0, 0, 0)) { example.run }
  end

  describe "#sign_jwt" do
    subject { signer.sign_jwt({ id: 1 }) }

    it "returns a token" do
      # https://jwt.io/#debugger-io?token=eyJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2ODQ4OTAwMDAsImlkIjoxfQ.t9uvKu-aolAjo8IDlREfAaZhfTS3CnBOm5F2PG7C5KY
      expect(subject.value).to eq("eyJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2ODQ4OTAwMDAsImlkIjoxfQ.t9uvKu-aolAjo8IDlREfAaZhfTS3CnBOm5F2PG7C5KY")
      expect(subject.expire_at).to eq(1.hour.from_now)
    end
  end

  describe "#verify_jwt" do
    subject { signer.verify_jwt("eyJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2ODQ4OTAwMDAsImlkIjoxfQ.t9uvKu-aolAjo8IDlREfAaZhfTS3CnBOm5F2PG7C5KY") }

    it "returns payload" do
      is_expected.to eq({ "exp" => 1.hour.from_now.to_i, "id" => 1 })
    end
  end

  describe "#sign" do
    subject { signer.sign({ id: 1, timestamp: Time.current.to_i }) }

    it "returns signed message" do
      is_expected.to eq("8325025d39fd103631b5a6677946b424c371a1e38c458103ae0132812a307b81")
    end
  end
end
