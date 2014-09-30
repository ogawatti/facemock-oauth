# -*- coding: utf-8 -*-

module Facemock
  module OAuth
    class Login < RackMiddleware
      class << self
        attr_accessor :path
      end

      VIEW_DIRECTORY = File.expand_path("../../../../view", __FILE__)
      VIEW_FILE_NAME = "login.html"
      DEFAULT_PATH = "/facemock/sign_in"
      @path = DEFAULT_PATH

      def call(env)
        if env["PATH_INFO"] == Login.path
          code   = 200
          body   = [ Login.view ]
          header = { "Content-Type"           => "text/html;charset=utf-8",
                     "Content-Length"         => content_length(body).to_s,
                     "X-XSS-Protection"       => "1; mode=block",
                     "X-Content-Type-Options" => "nosniff",
                     "X-Frame-Options"        => "SAMEORIGIN" }
          [code, header, body]
        else
          super
        end
      end

      def self.view
        File.read(filepath)
      end

      private

      def self.filepath
        File.join(VIEW_DIRECTORY, VIEW_FILE_NAME)
      end
    end
  end
end
