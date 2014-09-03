require 'spec_helper'

describe Facemock::Oauth do
  let(:version) { '0.0.1' }

  it 'should have a version number' do
    expect(Facemock::Oauth::VERSION).to eq version
  end
end
