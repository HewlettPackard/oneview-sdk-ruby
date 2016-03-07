require 'spec_helper'

RSpec.describe OneviewSDK::StorageSystem do
  include_context 'shared context'

  describe '#initialize' do
    context 'OneView 1.2' do
      it 'sets the defaults correctly' do
        item = OneviewSDK::StorageSystem.new(@client_120)
        expect(item[:type]).to eq('StorageSystemV2')
      end
    end

    context 'OneView 2.0' do
      it 'sets the defaults correctly' do
        item = OneviewSDK::StorageSystem.new(@client)
        expect(item[:type]).to eq('StorageSystemV3')
      end
    end
  end

  describe '#create' do
    it 'sends just the credentials hash, then the rest of the data' do
      item = OneviewSDK::StorageSystem.new(@client, name: 'Fake', credentials: { ip_hostname: 'a.com', username: 'admin', password: 'secret' })
      expect(@client).to receive(:rest_post).with('/rest/storage-systems', { 'body' => item['credentials'] }, item.api_version)
        .and_return(FakeResponse.new('uri' => '/rest/task/fake'))
      allow(@client).to receive(:wait_for).and_return(FakeResponse.new(nil, 200, 'associatedResource' => { 'resourceUri' => '/rest/fake' }))
      expect(item).to receive(:refresh).and_return(true)
      expect(item).to receive(:update).with('name' => 'Fake', 'type' => 'StorageSystemV3').and_return(true)
      item.create
    end
  end

  describe '#retrieve!' do
    it 'finds by name if it is set' do
      item = OneviewSDK::StorageSystem.new(@client, name: 'Fake')
      expect(OneviewSDK::Resource).to receive(:find_by).with(@client, name: 'Fake').and_return([item])
      expect(item.retrieve!).to eq(true)
    end

    it 'finds by credentials if the name is not set' do
      item = OneviewSDK::StorageSystem.new(@client, credentials: { ip_hostname: 'a.com', username: 'admin', password: 'secret' })
      expect(OneviewSDK::Resource).to receive(:find_by).with(@client, credentials: { ip_hostname: item['credentials'][:ip_hostname] })
        .and_return([item])
      expect(item.retrieve!).to eq(true)
    end
  end
end
