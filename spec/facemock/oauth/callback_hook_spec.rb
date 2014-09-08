require 'spec_helper'
require 'rack/test'

describe Facemock::OAuth::CallbackHook do
  include Rack::Test::Methods
  include TestApplicationHelper

  let(:test_app) { TestApplicationHelper::TestRackApplication }
  let(:app)      { Facemock::OAuth::CallbackHook.new(test_app.new) }
  let(:path)     { '/users/auth/callback' }

  describe '::DEFAULT_PATH' do
    subject { Facemock::OAuth::CallbackHook::DEFAULT_PATH }
    it { is_expected.to eq path }
  end

  describe '.path' do
    subject { Facemock::OAuth::CallbackHook.path }
    it { is_expected.to eq path }
  end

  describe "GET '/'", assert: :RequestSuccess do
    before { @path = '/' }
  end

  shared_context '200 OK and with AuthHash', assert: :SetAuthHash do
    it 'should return 302 Found' do
      get @path, code: @authorization_code.string
      expect(last_response.status).to eq 200
      expect(last_response.body).not_to be_nil
      expect(last_response.header).not_to be_empty
      expect(last_request.env['omniauth.auth']).to be_kind_of Facemock::AuthHash
      expect(last_request.env['omniauth.auth']).not_to be_empty
      expect(last_request.env['omniauth.auth']['provider']).to eq "facebook"
      expect(last_request.env['omniauth.auth']['uid']).to eq @user.id
    end
  end

  describe "GET '/users/auth/callback'" do
    context 'without code parameter', assert: :RequestSuccess do
      before { @path = '/' }
    end

    context 'with code parameter' do
      before do
        @user = Facemock::User.new({ id: 1, access_token: "test_token" })
        @authorization_code = Facemock::AuthorizationCode.new(user_id: @user.id)
      end

      context 'when authorization code does not found', assert: :RequestSuccess do
        before do
          allow(Facemock::AuthorizationCode).to receive(:find_by_string) { nil }
          @path = path + "?code=#{@authorization_code.string}"
        end
      end

      context 'when authorization code found but user does not found', assert: :RequestSuccess do
        before do
          allow(Facemock::AuthorizationCode).to receive(:find_by_string) { @authorization_code }
          allow(Facemock::User).to receive(:find_by_id) { nil }
          @path = path + "?code=#{@authorization_code.string}"
        end
      end

      context 'when authorization code found by code parameter', assert: :SetAuthHash do
        before do
          allow(Facemock::AuthorizationCode).to receive(:find_by_string) { @authorization_code }
          allow(Facemock::User).to receive(:find_by_id) { @user }
          allow(Facemock::User).to receive(:find_by_access_token) { @user }
          @path = path
        end
      end
    end
  end

  describe "GET '/test'" do
    context "when path variable set '/test'", assert: :SetAuthHash do
      before do
        @path = "/test"
        Facemock::OAuth::CallbackHook.path = @path

        @user = Facemock::User.new({ id: 1, access_token: "test_token" })
        @authorization_code = Facemock::AuthorizationCode.new(user_id: @user.id)
        allow(Facemock::AuthorizationCode).to receive(:find_by_string) { @authorization_code }
        allow(Facemock::User).to receive(:find_by_id) { @user }
        allow(Facemock::User).to receive(:find_by_access_token) { @user }
      end
      after  { Facemock::OAuth::CallbackHook.path = path }
    end
  end
end
