require 'spec_helper'

RSpec.describe OneviewSDK::API300::C7000::InternalLinkSet do
  include_context 'shared context'

  let(:item) { described_class.new(@client_300) }

  it 'inherits from Resource' do
    expect(described_class).to be < OneviewSDK::API300::C7000::Resource
  end

  describe '#create' do
    it 'raises a MethodUnavailable exception' do
      expect { item.create }.to raise_error(/The method #create is unavailable for this resource/)
    end
  end

  describe '#update' do
    it 'raises a MethodUnavailable exception' do
      expect { item.update }.to raise_error(/The method #update is unavailable for this resource/)
    end
  end

  describe '#delete' do
    it 'raises a MethodUnavailable exception' do
      expect { item.delete }.to raise_error(/The method #delete is unavailable for this resource/)
    end
  end

  describe '#get_internal_link_sets' do
    it 'finds the specified internal link set' do
      internal_link_set_list = FakeResponse.new(
        'members' => [
          { 'name' => 'InternalLinkSet1', 'uri' => 'rest/fake/internal-link-set' },
          { 'name' => 'InternalLinkSet2', 'uri' => 'rest/fake/B' },
          { 'name' => 'InternalLinkSet3', 'uri' => 'rest/fake/C' }
        ]
      )
      expect(@client_300).to receive(:rest_get).with('/rest/internal-link-sets').and_return(internal_link_set_list)
      item = described_class.get_internal_link_set(@client_300, 'InternalLinkSet1')
      expect(item['uri']).to eq('rest/fake/internal-link-set')
    end
  end
end
