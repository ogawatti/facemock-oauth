require 'spec_helper'

describe Facemock::OAuth do
  let(:version) { '0.0.6' }

  it 'should have a version number' do
    expect(Facemock::OAuth::VERSION).to eq version
  end
end
