module DevKit
  module Cryptographic
    class AsymmetricSigner
      attr_reader :public_key, :private_key, :algorithm

      def initialize(pub:, priv:, alg: "RS256")
        @public_key = OpenSSL::PKey::RSA.new(pub) if pub.present?
        @private_key = OpenSSL::PKey::RSA.new(priv) if priv.present?

        if pub.nil? && priv.nil?
          @private_key = OpenSSL::PKey::RSA.generate(2048)
          @public_key = @private_key.public_key
        end

        @algorithm = alg
      end

      def sign_jwt(message, expire_in_s: 3600)
        expire_at = expire_in_s.seconds.from_now
        token = JWT.encode({ exp: expire_at.to_i }.merge(message), private_key, algorithm)
        Token.new(value: token, expire_at: expire_at, duration_ms: expire_in_s * 1000)
      end

      def verify_jwt(signature)
        decoded = JWT.decode(signature, public_key, true, { algorithm: algorithm })
        ActiveSupport::HashWithIndifferentAccess.new(decoded.first)
      rescue JWT::VerificationError, JWT::DecodeError, JWT::IncorrectAlgorithm, JWT::ImmatureSignature, JWT::ExpiredSignature
        nil
      end
    end
  end
end
