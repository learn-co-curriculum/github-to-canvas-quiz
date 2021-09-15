# frozen_string_literal: true

module GithubToCanvasQuiz
  module CanvasAPI
    class Client
      include Endpoints

      attr_reader :host, :api_key

      def initialize(host:, api_key:)
        @host = host
        @api_key = api_key
      end

      private

      def get(endpoint)
        response = RestClient.get(host + endpoint, {
          'Authorization' => "Bearer #{api_key}"
        })
        JSON.parse(response)
      rescue RestClient::BadRequest => e
        report_error(e)
      end

      def get_all(endpoint)
        data = []
        url = host + endpoint
        while url
          response = RestClient.get(url, {
            'Authorization' => "Bearer #{api_key}"
          })
          data += JSON.parse(response)
          url = next_url(response.headers[:link])
        end
        data
      rescue RestClient::BadRequest => e
        report_error(e)
      end

      def post(endpoint, payload)
        response = RestClient.post(host + endpoint, payload, {
          'Authorization' => "Bearer #{api_key}"
        })
        JSON.parse(response)
      rescue RestClient::BadRequest => e
        report_error(e)
      end

      def put(endpoint, payload)
        response = RestClient.put(host + endpoint, payload, {
          'Authorization' => "Bearer #{api_key}"
        })
        JSON.parse(response)
      rescue RestClient::BadRequest => e
        report_error(e)
      end

      def delete(endpoint)
        RestClient.delete(host + endpoint, {
          'Authorization' => "Bearer #{api_key}"
        })
      rescue RestClient::BadRequest => e
        report_error(e)
      end

      def next_url(link)
        link.split(/,/).detect { |rel| rel.match(/rel="next"/) }.split(/;/).first.strip[1..-2]
      rescue NoMethodError
        nil
      end

      def report_error(err)
        puts "Request failed. #{err.response.code} status code returned."
        puts JSON.parse(err.response.body)
        abort
      end
    end
  end
end
