require 'spec_helper'

RSpec.describe OneviewSDK::API500::C7000::LogicalEnclosure do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API300::C7000::LogicalEnclosure' do
    expect(described_class).to be < OneviewSDK::API300::C7000::LogicalEnclosure
  end

  describe '#create' do
    it 'is unavailable' do
      item = described_class.new(@client_500)
      expect { item.create }.to raise_error(/The method #create is unavailable for this resource/)
    end
  end

  describe '#delete' do
    it 'is unavailable' do
      item = described_class.new(@client_500)
      expect { item.delete }.to raise_error(/The method #delete is unavailable for this resource/)
    end
  end

  describe '#update' do
    it 'updates the name' do
      item = described_class.new(@client_500, name: 'Name', uri: '/rest/fake')
      options = { 'name' => 'updatedName', 'uri' => '/rest/fake' }
      expect(@client_500).to receive(:rest_put)
        .with('/rest/fake', { 'body' => options }, @client_500.api_version).and_return(FakeResponse.new)
      allow_any_instance_of(described_class).to receive(:retrieve!).and_return(true)
      item.update(name: 'updatedName')
      expect(item['name']).to eq('updatedName')
    end
  end

  describe '#perfoms a specific patch' do
    it 'requires a uri' do
      item = described_class.new(@client_500)
      expect { item.patch('any') }.to raise_error(OneviewSDK::IncompleteResource, /Please set uri/)
    end

    it 'performs a patch' do
      item = described_class.new(@client_500, uri: '/rest/fake', eTag: 'anyTag')
      options = {
        'If-Match' => item['eTag'],
        'body' => [{ op: 'replace', path: '/firmware', value: 'val' }]
      }
      expect(@client_500).to receive(:rest_patch).with(item['uri'], options, item.api_version).and_return(FakeResponse.new)
      allow_any_instance_of(described_class).to receive(:retrieve!).and_return(true)
      item.patch('val')
    end
  end
end
