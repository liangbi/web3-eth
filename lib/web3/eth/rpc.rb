module Web3
  module Eth

    class Rpc

      require 'json'
      require 'net/http'

      JSON_RPC_VERSION = '2.0'

      DEFAULT_CONNECT_OPTIONS = {
          use_ssl: false,
          open_timeout: 10,
          read_timeout: 70
      }

      DEFAULT_HOST = 'localhost'
      DEFAULT_PORT = 8545

      def initialize host: DEFAULT_HOST, port: DEFAULT_PORT, connect_options: DEFAULT_CONNECT_OPTIONS

        @client_id = Random.rand 10000000

        @uri = URI((connect_options[:use_ssl] ? 'https' : 'http')+ "://#{host}:#{port}")
        @connect_options = connect_options

        @eth = Ethereum.new self
      end


      def eth
        @eth
      end


      def request method, params = nil


        Net::HTTP.start(@uri.host, @uri.port, @connect_options) do |http|

          request = Net::HTTP::Post.new @uri, {"Content-Type" => "application/json"}
          request.body = {:jsonrpc => JSON_RPC_VERSION, method: method, params: params, id: @client_id}.compact.to_json
          response = http.request request

          raise "Error code #{response.code} on request #{@uri.to_s} #{request.body}" unless response.kind_of? Net::HTTPOK

          json = JSON.parse(response.body)['result']
          raise "No response on request #{@uri.to_s} #{request.body}" unless json

          json

        end

      end


    end
  end
end