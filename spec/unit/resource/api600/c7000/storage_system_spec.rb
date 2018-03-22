require 'spec_helper'

RSpec.describe OneviewSDK::API600::C7000::StorageSystem do
  include_context 'shared context'

  let(:client) { @client_600 }
  let(:empty_item) { described_class.new(client) }

  it 'the UNIQUE_IDENTIFIERS shoud have name, uri and hostname' do
    expect(described_class::UNIQUE_IDENTIFIERS).to eq(%w[name uri hostname])
  end

  it 'inherits from OneviewSDK::API500::C7000::StorageSystem' do
    expect(described_class).to be < OneviewSDK::API500::C7000::StorageSystem
  end
end
