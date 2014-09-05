require 'spec_helper'
require 'rack/test'

describe Facemock::OAuth::Authentication do
  include Rack::Test::Methods
  include TestApplicationHelper

  let(:test_app)     { TestApplicationHelper::TestRackApplication }
  let(:app)          { Facemock::OAuth::Authentication.new(test_app.new) }
  let(:path)         { '/facemock/oauth' }
  let(:failed_path)  { '/facemock/sign_in' }
  let(:email)        { 'test@example.org' }
  let(:password)     { 'password' }
  let(:body)         { URI.escape("email=#{email}&pass=#{password}", "@&") }
  let(:content_type) { 'application/x-www-form-urlencoded' }
  let(:header)       { { 'CONTENT_TYPE' => content_type } }

  describe '::DEFAULT_PATH' do
    subject { Facemock::OAuth::Authentication::DEFAULT_PATH }
    it { is_expected.to eq path }
  end

  describe '.path' do
    subject { Facemock::OAuth::Authentication.path }
    it { is_expected.to eq path }
  end

  describe "GET '/'", assert: :RequestSuccess do
    before { @path = '/' }
  end

  describe "GET  '/facemock/oauth'", assert: :RequestSuccess do
    before { @path = path }
  end

  shared_context '302 Found OAuth Callback', assert: :RedirectToOAuthCallback do
    it 'should return 302 Found that location path is Facemock::OAuth::CallbackHook.path' do
      post @path, body, header
      expect(last_response.status).to eq 302
      expect(last_response.body).to be_empty
      expect(last_response.header["Content-Type"]).to eq "text/html;charset=utf-8"
      expect(last_response.header["Content-Length"]).to eq "0"
      expect(last_response.header["X-XSS-Protection"]).to eq "1; mode=block"
      expect(last_response.header["X-Content-Type-Options"]).to eq "nosniff"
      expect(last_response.header["X-Frame-Options"]).to eq "SAMEORIGIN"
      code = @authorization_code.string
      expect_url = "http://example.org" + Facemock::OAuth::CallbackHook.path + "?code=#{code}"
      expect(last_response.header["Location"]).to eq expect_url
    end
  end

  describe "POST '/facemock/oauth'" do
    context 'when user does not found by email' do
      it "should return 302 Found that location path is '/facemock/sign_in'" do
        post path, body, header
        expect(last_response.status).to eq 302
        expect(last_response.body).to be_empty
        expect(last_response.header["Content-Type"]).to eq "text/html;charset=utf-8"
        expect(last_response.header["Content-Length"]).to eq "0"
        expect(last_response.header["X-XSS-Protection"]).to eq "1; mode=block"
        expect(last_response.header["X-Content-Type-Options"]).to eq "nosniff"
        expect(last_response.header["X-Frame-Options"]).to eq "SAMEORIGIN"
        expect(last_response.header["Location"]).to eq "http://example.org" + failed_path
      end
    end

    context 'when user found', assert: :RedirectToOAuthCallback do
      before do
        @user = Facemock::Database::User.new({id: 1, email: email, password: password})
        allow(Facemock::Database::User).to receive(:find_by_email) { @user }
        @authorization_code = Facemock::Database::AuthorizationCode.new(user_id: @user.id)
        allow(Facemock::Database::AuthorizationCode).to receive(:create!) { @authorization_code }
        @path = path
      end
    end
  end

  describe "POST '/test'" do
    context "with correct body when path variable set '/test'", assert: :RedirectToOAuthCallback do
      before do
        @path = "/test"
        Facemock::OAuth::Authentication.path = @path

        @user = Facemock::Database::User.new({id: 1, email: email, password: password})
        allow(Facemock::Database::User).to receive(:find_by_email) { @user }
        @authorization_code = Facemock::Database::AuthorizationCode.new(user_id: @user.id)
        allow(Facemock::Database::AuthorizationCode).to receive(:create!) { @authorization_code }
      end
      after  { Facemock::OAuth::Authentication.path = path }
    end
  end
end
