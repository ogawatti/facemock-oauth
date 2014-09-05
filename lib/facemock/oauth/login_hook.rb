module Facemock
  module OAuth
    class LoginHook < RackMiddleware
      DEFAULT_PATH = "/sign_in"
      @path = DEFAULT_PATH

      def call(env)
        res = super
        if env["PATH_INFO"] == LoginHook.path
          code   = 302
          body   = []
          header = { "Content-Type"           => "text/html;charset=utf-8",
                     "Location"               => location(env, "/facemock/sign_in"),
                     "Content-Length"         => content_length(body).to_s,
                     "X-XSS-Protection"       => "1; mode=block",
                     "X-Content-Type-Options" => "nosniff",
                     "X-Frame-Options"        => "SAMEORIGIN" }
          res = [ code, header, body ]
        end
        res
      end
    end
  end
end
