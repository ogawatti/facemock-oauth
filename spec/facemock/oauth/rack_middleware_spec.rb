require 'spec_helper'
require 'rack/test'

describe Facemock::OAuth::RackMiddleware do
  include Rack::Test::Methods
  include TestApplicationHelper

  let(:test_app) { TestApplicationHelper::TestRackApplication }
  let(:app) { Facemock::OAuth::RackMiddleware.new(test_app.new) }

  describe "GET '/'", assert: :RequestSuccess do
    before { @path = '/' }
  end
end
