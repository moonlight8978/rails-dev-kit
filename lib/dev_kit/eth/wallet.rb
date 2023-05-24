module DevKit
  module Eth
    class Wallet
      DOMAIN_TYPES = [
        { name: "name", type: "string" },
        { name: "version", type: "string" },
        { name: "chainId", type: "uint256" },
        { name: "verifyingContract", type: "address" },
        { name: "salt", type: "bytes32" }
      ]

      attr_reader :key, :address

      def initialize(priv: nil, pub: nil)
        @address = ::Eth::Address.new(pub) if pub.present?

        if priv.present?
          @key = ::Eth::Key.new(priv: priv)
          @address = @key.address
        end
      end

      def typed_data_valid?(domain, types, value, signature, chain_id = 1)
        domain_types = DOMAIN_TYPES.select do |type|
          domain.key?(type[:name].to_sym) || domain.key?(type[:name])
        end

        public_hex = ::Eth::Signature.recover_typed_data(
          {
            message: value,
            primaryType: types.keys.first.to_s,
            types: types.merge(EIP712Domain: domain_types),
            domain: domain
          },
          signature,
          chain_id,
        )

        public_key = ::Eth::Util.public_key_to_address(public_hex)
        public_key.checksummed == @address.checksummed
      rescue ::Eth::Signature::SignatureError, Secp256k1::DeserializationError, ::Eth::Chain::ReplayProtectionError
        false
      end
    end
  end
end
