require 'facemock'

module Facemock
  module OAuth
    class Authentication < RackMiddleware
      DEFAULT_PATH = "/facemock/oauth"
      @path = DEFAULT_PATH

      def call(env)
        if env["PATH_INFO"] == Authentication.path && env["REQUEST_METHOD"] == "POST"
          raw_body = URI.unescape(env['rack.input'].gets)
          body     = query_string_to_hash(raw_body)
          email    = body["email"]
          password = body["pass"]

          user = Facemock::Database::User.find_by_email(email)
          if user && user.password == password
            code = Facemock::Database::AuthorizationCode.create!(user_id: user.id)
            location = location(env, CallbackHook.path, { code: code.string })
          else
            location = location(env, "/facemock/sign_in")
          end

          code   = 302
          body   = []
          header = { "Content-Type"           => "text/html;charset=utf-8",
                     "Location"               => location,
                     "Content-Length"         => content_length(body).to_s,
                     "X-XSS-Protection"       => "1; mode=block",
                     "X-Content-Type-Options" => "nosniff",
                     "X-Frame-Options"        => "SAMEORIGIN" }
          [ code, header, body ]
        else
          super
        end
      end
    end
  end
end
