require 'spec_helper'
require 'rack/test'

describe Facemock::OAuth::Login do
  include Rack::Test::Methods
  include TestApplicationHelper

  let(:test_app) { TestApplicationHelper::TestRackApplication }
  let(:app)      { Facemock::OAuth::Login.new(test_app.new) }
  let(:path)     { "/facemock/sign_in" }

  describe '::DEFAULT_PATH' do
    subject { Facemock::OAuth::Login::DEFAULT_PATH }
    it { is_expected.to eq path }
  end

  describe '.path' do
    subject { Facemock::OAuth::Login.path }
    it { is_expected.to eq path }
  end

  describe '.path=' do
    context 'with "/test"' do
      before { @path = "/test" }
      after  { Facemock::OAuth::Login.path = path }

      it 'should set class instance variable path' do
        Facemock::OAuth::Login.path = @path
        expect(Facemock::OAuth::Login.path).to eq @path
      end
    end
  end

  shared_context '200 OK Signin View', assert: :GetFacemockLoginHtml do
    it 'should return 200 OK' do
      html = Facemock::OAuth::Login.view
      get @path
      expect(last_response.status).to eq 200
      expect(last_response.body).to eq html
      expect(last_response.header["Content-Type"]).to eq "text/html;charset=utf-8"
      expect(last_response.header["Content-Length"]).to eq html.bytesize.to_s
      expect(last_response.header["X-XSS-Protection"]).to eq "1; mode=block"
      expect(last_response.header["X-Content-Type-Options"]).to eq "nosniff"
      expect(last_response.header["X-Frame-Options"]).to eq "SAMEORIGIN"
    end
  end

  describe "GET '/'", assert: :RequestSuccess do
    before { @path = '/' }
  end

  describe "GET '/facemock/sign_in'", assert: :GetFacemockLoginHtml do
    before { @path = path }
  end

  describe "GET '/test'" do
    context "when path variable set '/test'", assert: :GetFacemockLoginHtml do
      before do
        @path = "/test"
        Facemock::OAuth::Login.path = @path
      end
      after  { Facemock::OAuth::Login.path = path }
    end
  end
end
