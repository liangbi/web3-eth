module Web3
  module Eth

    class Transaction

      include Web3::Eth::Utility

      attr_reader :raw_data

      def initialize transaction_data
        @raw_data = transaction_data

        transaction_data.each do |k, v|
          self.instance_variable_set("@#{k}", v)
          self.class.send(:define_method, k, proc {self.instance_variable_get("@#{k}")})
        end


      end

      def block_number
        from_hex blockNumber
      end

      def value_eth
        wei_to_ether from_hex value
      end

      def gas_eth
        wei_to_ether from_hex gas
      end

      def gasPrice_eth
        wei_to_ether from_hex gasPrice
      end

    end
  end
end