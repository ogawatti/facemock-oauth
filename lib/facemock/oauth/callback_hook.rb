require 'facemock'

module Facemock
  module OAuth
    class CallbackHook < RackMiddleware
      class << self
        attr_accessor :path
      end

      DEFAULT_PATH = "/users/auth/callback"
      @path = DEFAULT_PATH

      def call(env)
        if env["PATH_INFO"] == CallbackHook.path
          query = query_string_to_hash(env["QUERY_STRING"])
          if access_token = get_access_token(query["code"])
            env["omniauth.auth"] = Facemock.auth_hash(access_token)
          end
        end
        super(env)
      end

      private

      def get_access_token(code)
        authorization_code = Facemock::AuthorizationCode.find_by_string(code)
        if authorization_code
          user = Facemock::User.find_by_id(authorization_code.user_id)
          user ? user.access_token : nil
        else
          nil
        end
      end
    end
  end
end
