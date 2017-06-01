require 'spec_helper'

RSpec.describe OneviewSDK::API500::C7000::Enclosure do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API300::C7000::Enclosure' do
    expect(described_class).to be < OneviewSDK::API300::C7000::Enclosure
  end

  describe '#initialize' do
    context 'OneView 3.10' do
      it 'sets the defaults correctly' do
        enclosure = described_class.new(@client_500)
        expect(enclosure[:type]).to eq('EnclosureV400')
      end
    end
  end

  describe '#update' do
    before :each do
      @item  = described_class.new(@client_500, name: 'E1', rackName: 'R1', uri: '/rest/fake', eTag: 'anyTag')
      @item2 = described_class.new(@client_500, name: 'E2', rackName: 'R1', uri: '/rest/fake2', eTag: 'anyTag2')
      @item3 = described_class.new(@client_500, name: 'E1', rackName: 'R2', uri: '/rest/fake2', eTag: 'anyTag3')
    end

    it 'requires a uri' do
      expect { described_class.new(@client_500).update }.to raise_error(OneviewSDK::IncompleteResource, /Please set uri/)
    end

    it 'does not send a PATCH request if the name and rackName are the same' do
      expect(described_class).to receive(:find_by).with(@client_500, uri: @item['uri']).and_return([@item])
      allow_any_instance_of(described_class).to receive(:retrieve!).and_return(true)
      expect(@client_500).to_not receive(:rest_patch)
      @item.update
    end

    it 'updates the server name with the local name' do
      options = {
        'If-Match' => @item['eTag'],
        'body' => [{ 'op' => 'replace', 'path' => '/name', 'value' => @item['name'] }]
      }
      expect(described_class).to receive(:find_by).with(@client_500, uri: @item['uri']).and_return([@item2])
      allow_any_instance_of(described_class).to receive(:retrieve!).and_return(true)
      expect(@client_500).to receive(:rest_patch)
        .with(@item['uri'], options, @item.api_version)
        .and_return(FakeResponse.new)
      @item.update
    end

    it 'updates the server rackName with the local rackName' do
      options = {
        'If-Match' => @item['eTag'],
        'body' => [{ 'op' => 'replace', 'path' => '/rackName', 'value' => @item['rackName'] }]
      }
      expect(described_class).to receive(:find_by).with(@client_500, uri: @item['uri']).and_return([@item3])
      allow_any_instance_of(described_class).to receive(:retrieve!).and_return(true)
      expect(@client_500).to receive(:rest_patch)
        .with(@item['uri'], options, @item.api_version)
        .and_return(FakeResponse.new)
      @item.update
    end
  end

  describe '#patch' do
    it 'performs a patch' do
      item = described_class.new(@client_500, uri: '/rest/fake', eTag: 'anyTag')
      options = {
        'If-Match' => item['eTag'],
        'body' => [{ 'op' => 'add', 'path' => '/scopeUris/-', 'value' => '/rest/scopes/fake' }]
      }
      expect(@client_500).to receive(:rest_patch)
        .with(item['uri'], options, item.api_version)
        .and_return(FakeResponse.new)
      item.patch('add', '/scopeUris/-', '/rest/scopes/fake')
    end
  end
end
