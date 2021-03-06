require 'faraday'
require 'payture'

module FaradayMiddleware
  # Converts parsed response bodies to underscored keys if bodies were of
  # Hash type.
  class Underscore < Faraday::Response::Middleware

    def initialize(app = nil, options = {})
      super(app)
    end

    def parse(body)
      convert_hash_keys body
    end

    private

      def convert_hash_keys(value)
        case value
        when Array
          value.map(&method(:convert_hash_keys))
        when Hash
          Hash[value.map { |k, v| [Payture::Helper.convert_to_underscore(k), convert_hash_keys(v)] }]
        else
          value
        end
      end

  end
end


