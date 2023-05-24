module DevKit
  module Cryptographic
    class SymmetricSigner
      attr_reader :secret, :algorithm

      def initialize(secret:, alg: 'HS256')
        @secret = secret
        @algorithm = alg
      end

      def sign(message)
        message = message.is_a?(String) ? message : JSON.generate(message)
        OpenSSL::HMAC.hexdigest('sha256', secret, message)
      end

      def sign_jwt(message, expire_in_s: 3600)
        expire_at = expire_in_s.seconds.from_now
        token = JWT.encode({ exp: expire_at.to_i }.merge(message), secret, 'HS256')
        Token.new(value: token, expire_at: expire_at, duration_ms: expire_in_s * 1000)
      end

      def verify_jwt(signature)
        decoded = JWT.decode(signature, secret, true, { algorithm: algorithm })
        ActiveSupport::HashWithIndifferentAccess.new(decoded.first)
      rescue JWT::VerificationError, JWT::DecodeError, JWT::IncorrectAlgorithm, JWT::ImmatureSignature, JWT::ExpiredSignature
        nil
      end
    end
  end
end
