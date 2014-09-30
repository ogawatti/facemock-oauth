require 'rack'

module Facemock
  module OAuth
    class RackMiddleware
      def initialize(app)
        @app = app
      end

      def call(env)
        @app.call(env)
      end

      private

      def content_length(body)
        body.inject(0) do |sum, content|
          sum + content.bytesize
        end
      end

      def location(env, path, query={})
        scheme = env["rack.url_scheme"]
        host   = env["HTTP_HOST"]
        query_string = ""
        query_string = "?" + hash_to_query_string(query) unless query.empty?
        url = scheme + "://" + host + path + query_string
      end

      def query_string_to_hash(query_string)
        query_string.split("&").inject({}) do |hash, str|
          key, value = str.split("=")
          hash[key] = value
          hash
        end
      end

      def hash_to_query_string(query)
        query_strings = query.inject([]) do |ary, (key,value)|
          ary << "#{key}=#{value}"
        end
        query_strings.join("&")
      end
    end
  end
end
