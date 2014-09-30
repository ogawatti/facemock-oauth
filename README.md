[![Gem Version](https://badge.fury.io/rb/facemock-oauth.svg)](http://badge.fury.io/rb/facemock-oauth)
[![Build Status](https://travis-ci.org/ogawatti/facemock-oauth.svg?branch=master)](https://travis-ci.org/ogawatti/facemock-oauth)
[![Coverage Status](https://coveralls.io/repos/ogawatti/facemock-oauth/badge.png?branch=master)](https://coveralls.io/r/ogawatti/facemock-oauth?branch=master)
[<img src="https://gemnasium.com/ogawatti/facemock-oauth.png" />](https://gemnasium.com/ogawatti/facemock-oauth)
[![Code Climate](https://codeclimate.com/github/ogawatti/facemock-oauth/badges/gpa.svg)](https://codeclimate.com/github/ogawatti/facemock-oauth)

# Facemock::Oauth

Facemock::OAuth will mock the oauth of facebook using facemock.

## Installation

Add this line to your application's Gemfile:

    gem 'facemock-oauth'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install facemock-oauth

## Usage

### Facemock OAuth

for Rails

    $ vi config/routes.rb

    YourApp::Application.routes.draw do
      devise_scope :user do
        match ':provider/sign_in',            to: 'your_sign_in_controller'
        match 'users/facemock/auth/callback', to: 'your_callback_controller'
      end
    end

    $ vi config/environments/development.rb

    Facemock::OAuth::LoginHook.paths   = [ '/facebook/sign_in', '/user/facebook/sign_in' ]
    Facemock::OAuth::CallbackHook.path = '/users/facemock/auth/callback'

    config.middleware.use Facemock::OAuth::LoginHook
    config.middleware.use Facemock::OAuth::Login
    config.middleware.use Facemock::OAuth::Authentication
    config.middleware.use Facemock::OAuth::CallbackHook

for Sinatra

    $ vi config.ru

    require 'sinatra'
    require 'facemock-oauth'

    Facemock::OAuth::LoginHook.paths   = [ '/facebook/sign_in', '/user/facebook/sign_in' ]
    Facemock::OAuth::CallbackHook.path = '/users/facemock/auth/callback'

    use Facemock::OAuth::LoginHook
    use Facemock::OAuth::Login
    use Facemock::OAuth::Authentication
    use Facemock::OAuth::CallbackHook

    require File.expand_path 'app', File.dirname(__FILE__)

    run Sinatra::Application

### User registration to Facemock

See the [https://github.com/ogawatti/facemock](facemock).

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
