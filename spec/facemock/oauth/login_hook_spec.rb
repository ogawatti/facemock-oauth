require 'spec_helper'
require 'rack/test'

describe Facemock::OAuth::LoginHook do
  include Rack::Test::Methods
  include TestApplicationHelper

  let(:test_app) { TestApplicationHelper::TestRackApplication }
  let(:app)      { Facemock::OAuth::LoginHook.new(test_app.new) }
  let(:path)     { "/sign_in" }

  describe '::DEFAULT_PATH' do
    subject { Facemock::OAuth::LoginHook::DEFAULT_PATH }
    it { is_expected.to eq path }
  end

  describe '.path' do
    subject { Facemock::OAuth::LoginHook.paths }
    it { is_expected.to eq [ path ] }
  end

  describe '.path=' do
    context 'with "/test"' do
      before { @path = "/test" }
      after  { Facemock::OAuth::LoginHook.paths = [ path ] }

      it 'should set class instance variable path' do
        Facemock::OAuth::LoginHook.paths << @path
        expect(Facemock::OAuth::LoginHook.paths).to include path
        expect(Facemock::OAuth::LoginHook.paths).to include @path
      end
    end
  end

  shared_context '302 Found Signin', assert: :RedirectToFacemockSignin do
    it 'should return 302 Found' do
      get @path
      expect(last_response.status).to eq 302
      expect(last_response.body).to be_empty
      expect(last_response.header["Content-Type"]).to eq "text/html;charset=utf-8"
      expect(last_response.header["Content-Length"]).to eq "0"
      expect(last_response.header["X-XSS-Protection"]).to eq "1; mode=block"
      expect(last_response.header["X-Content-Type-Options"]).to eq "nosniff"
      expect(last_response.header["X-Frame-Options"]).to eq "SAMEORIGIN"
    end
  end

  describe "GET '/'", assert: :RequestSuccess do
    before { @path = '/' }
  end

  describe "GET '/sign_in'" do
    context 'when path is default value', assert: :RedirectToFacemockSignin do
      before { @path = path }
    end

    context 'when path variable set ather path', assert: :RequestSuccess do
      before do
        @path = path
        Facemock::OAuth::LoginHook.paths = [ "/test" ]
      end
      after  { Facemock::OAuth::LoginHook.paths = [ path ] }
    end
  end

  describe "GET '/test'" do
    context "when path variable set '/test'", assert: :RedirectToFacemockSignin do
      before do
        @path = "/test"
        Facemock::OAuth::LoginHook.paths = [ @path ]
      end
      after  { Facemock::OAuth::LoginHook.paths = [ path ] }
    end
  end
end
