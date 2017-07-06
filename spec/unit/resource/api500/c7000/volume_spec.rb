require 'spec_helper'

RSpec.describe OneviewSDK::API500::C7000::Volume do
  include_context 'shared context'

  let(:options) do
    {
      name: 'Volume 1',
      description: 'Volume store serv',
      size: 1024 * 1024 * 1024,
      provisioningType: 'Thin',
      isShareable: false
    }
  end

  let(:fake_response) { FakeResponse.new }

  let(:vol_template_class) { OneviewSDK::API500::C7000::VolumeTemplate }

  it 'inherits from OneviewSDK::API300::C7000::Volume' do
    expect(described_class).to be < OneviewSDK::API300::C7000::Volume
  end

  describe '#set_storage_system' do
    it 'is unavailable' do
      item = described_class.new(@client_500)
      expect { item.set_storage_system }.to raise_error(OneviewSDK::MethodUnavailable, /The method #set_storage_system is unavailable/)
    end
  end

  describe '#create' do
    it 'creating a volume - Store Serv' do
      item = described_class.new(@client_500, properties: options)
      vol_template = vol_template_class.new(@client_500, uri: '/rest/fake-template')
      options_template = { isRoot: true, family: 'StoreServ' }
      expect(vol_template_class).to receive(:find_by).with(@client_500, options_template).and_return([vol_template])
      data = { 'properties' => options, 'templateUri' => vol_template['uri'] }
      allow_any_instance_of(OneviewSDK::Client).to receive(:rest_post)
        .with(described_class::BASE_URI, { 'body' => data }, 500).and_return(fake_response)
      expect(@client_500).to receive(:response_handler).with(fake_response).and_return('uri' => '/rest/fake')
      item.create
      expect(item['uri']).to eq('/rest/fake')
    end

    it 'creating a volume with template - Store Serv' do
      item = described_class.new(@client_500, properties: options, templateUri: '/rest/template-fake')
      data = { 'properties' => options, 'templateUri' => '/rest/template-fake' }
      allow_any_instance_of(OneviewSDK::Client).to receive(:rest_post)
        .with(described_class::BASE_URI, { 'body' => data }, 500).and_return(fake_response)
      expect(@client_500).to receive(:response_handler).with(fake_response).and_return('uri' => '/rest/fake')
      item.create
      expect(item['uri']).to eq('/rest/fake')
    end

    it 'creating a volume - Store Virtual' do
      item = described_class.new(@client_500, properties: options.merge(dataProtectionLevel: 'anyLevel'))
      vol_template = vol_template_class.new(@client_500, uri: '/rest/fake-template')
      options_template = { isRoot: true, family: 'StoreVirtual' }
      expect(vol_template_class).to receive(:find_by).with(@client_500, options_template).and_return([vol_template])
      data = { 'properties' => options.merge(dataProtectionLevel: 'anyLevel'), 'templateUri' => vol_template['uri'] }
      allow_any_instance_of(OneviewSDK::Client).to receive(:rest_post)
        .with(described_class::BASE_URI, { 'body' => data }, 500).and_return(fake_response)
      expect(@client_500).to receive(:response_handler).with(fake_response).and_return('uri' => '/rest/fake')
      item.create
      expect(item['uri']).to eq('/rest/fake')
    end
  end

  describe '#delete' do
    it 'raises an exception when is passed as invalid flag' do
      allow_any_instance_of(OneviewSDK::Client).to receive(:response_handler).and_return(true)
      item = described_class.new(@client_500, uri: '/rest/fake')
      expect { item.delete(:any) }.to raise_error(/Invalid flag value, use :oneview or :all/)
    end

    it 'passes an extra header' do
      allow_any_instance_of(OneviewSDK::Client).to receive(:response_handler).and_return(true)
      item = described_class.new(@client_500, uri: '/rest/fake', eTag: 'anyTag')
      expect(@client_500).to receive(:rest_api).with(:delete, '/rest/fake?suppressDeviceUpdates=true', { 'If-Match' => 'anyTag' }, 500)
      item.delete(:oneview)
    end

    it 'removing all' do
      allow_any_instance_of(OneviewSDK::Client).to receive(:response_handler).and_return(true)
      item = described_class.new(@client_500, uri: '/rest/fake', eTag: 'anyTag')
      expect(@client_500).to receive(:rest_api).with(:delete, '/rest/fake', { 'If-Match' => 'anyTag' }, 500)
      item.delete(:all)
    end
  end

  describe '#set_storage_pool' do
    it 'sets the storagePool attribute' do
      item = described_class.new(@client_500)
      item.set_storage_pool(OneviewSDK::StoragePool.new(@client_500, uri: '/rest/fake'))
      expect(item['properties']['storagePool']).to eq('/rest/fake')
    end
  end

  describe '#set_snapshot_pool' do
    it 'sets the snapshotPool attribute' do
      item = described_class.new(@client_500)
      item.set_snapshot_pool(OneviewSDK::StoragePool.new(@client_500, uri: '/rest/fake'))
      expect(item['properties']['snapshotPool']).to eq('/rest/fake')
    end
  end

  describe '#create_from_snapshot' do
    before :each do
      template_options = { uri: '/rest/fake-template', storagePoolUri: '/rest/storage-pool/fake' }
      @vol_template = OneviewSDK::API500::C7000::VolumeTemplate.new(@client_500, template_options)
      @snapshot_options = { 'name' => 'Vol1_Snapshot1', 'description' => 'New Snapshot', 'uri' => '/rest/snapshot/fake' }
      @snapshots = [OneviewSDK::API500::C7000::VolumeSnapshot.new(@client_500, @snapshot_options)]

      @properties = {
        'provisioningType' => 'Thin',
        'name' => 'Volume1',
        'isShareable' => false
      }

      @data = {
        'properties' => {
          'provisioningType' => 'Thin',
          'name' => 'Volume1',
          'isShareable' => false,
          'storagePool' => @vol_template['storagePoolUri'],
          'snapshotPool' => @vol_template['storagePoolUri']
        },
        'snapshotUri' => @snapshot_options['uri'],
        'templateUri' => @vol_template['uri'],
        'isPermanent' => true
      }
      @fake_response1 = FakeResponse.new
      @fake_response2 = FakeResponse.new
    end

    it 'raises an exception when snapshot not found' do
      item = described_class.new(@client_500, uri: '/rest/fake')
      expect(@client_500).to receive(:rest_get).with("#{item['uri']}/snapshots", {}).and_return(@fake_response1)
      allow_any_instance_of(OneviewSDK::Client).to receive(:response_handler).with(@fake_response1).and_return('members' => @snapshots)
      expect { item.create_from_snapshot('Any', @properties) }.to raise_error(/Snapshot not found/)
    end

    it 'raises an exception when template not found' do
      item = described_class.new(@client_500, uri: '/rest/fake')
      allow_any_instance_of(vol_template_class).to receive(:retrieve!).and_return(false)
      expect(@client_500).to receive(:rest_get).with("#{item['uri']}/snapshots", {}).and_return(@fake_response1)
      allow_any_instance_of(OneviewSDK::Client).to receive(:response_handler).with(@fake_response1).and_return('members' => @snapshots)
      expect { item.create_from_snapshot('Vol1_Snapshot1', @properties, @vol_template) }.to raise_error(/Volume Template not found/)
    end

    it 'creating from snapshot' do
      item = described_class.new(@client_500, uri: '/rest/fake')
      allow_any_instance_of(vol_template_class).to receive(:retrieve!).and_return(@vol_template)
      expect(@client_500).to receive(:rest_get).with("#{item['uri']}/snapshots", {}).and_return(@fake_response1)
      allow_any_instance_of(OneviewSDK::Client).to receive(:response_handler).with(@fake_response1).and_return('members' => @snapshots)
      allow_any_instance_of(OneviewSDK::Client).to receive(:rest_post)
        .with("#{described_class::BASE_URI}/from-snapshot", { 'body' => @data }, 500).and_return(@fake_response2)
      expect(@client_500).to receive(:response_handler).with(@fake_response2).and_return('uri' => '/rest/fake2')
      volume = item.create_from_snapshot('Vol1_Snapshot1', @properties, @vol_template)
      expect(volume['uri']).to eq('/rest/fake2')
    end

    it 'creating from snapshot with root template' do
      item = described_class.new(@client_500, uri: '/rest/fake', storagePoolUri: '/rest/storage-pool/fake')
      options_template = { isRoot: true, family: 'StoreServ' }
      expect(vol_template_class).to receive(:find_by).with(@client_500, options_template).and_return([@vol_template])
      expect(@client_500).to receive(:rest_get).with("#{item['uri']}/snapshots", {}).and_return(@fake_response1)
      allow_any_instance_of(OneviewSDK::Client).to receive(:response_handler).with(@fake_response1).and_return('members' => @snapshots)
      allow_any_instance_of(OneviewSDK::Client).to receive(:rest_post)
        .with("#{described_class::BASE_URI}/from-snapshot", { 'body' => @data }, 500).and_return(@fake_response2)
      expect(@client_500).to receive(:response_handler).with(@fake_response2).and_return('uri' => '/rest/fake2')
      volume = item.create_from_snapshot('Vol1_Snapshot1', @properties)
      expect(volume['uri']).to eq('/rest/fake2')
    end
  end

  describe '#self.add' do
    before :each do
      @storage_system_class = OneviewSDK::API500::C7000::StorageSystem
      @storage_system = @storage_system_class.new(@client_500, uri: '/rest/storage-system/fake')
    end

    it 'raises an exception when storage system not found' do
      allow_any_instance_of(@storage_system_class).to receive(:retrieve!).and_return(false)
      expect { described_class.add(@client_500, @storage_system, 'volume') }.to raise_error(/Storage system not found/)
    end

    it 'adding a volume' do
      allow_any_instance_of(@storage_system_class).to receive(:retrieve!).and_return(true)
      data = {
        'storageSystemUri' => @storage_system['uri'],
        'deviceVolumeName' => 'volume',
        'isShareable' => false
      }

      allow_any_instance_of(OneviewSDK::Client).to receive(:rest_post)
        .with("#{described_class::BASE_URI}/from-existing", { 'body' => data }, 500).and_return(fake_response)
      expect(@client_500).to receive(:response_handler).with(fake_response).and_return('uri' => '/rest/fake2')
      volume = described_class.add(@client_500, @storage_system, 'volume')
      expect(volume['uri']).to eq('/rest/fake2')
    end

    it 'adding a volume with options' do
      allow_any_instance_of(@storage_system_class).to receive(:retrieve!).and_return(true)
      data = {
        'storageSystemUri' => @storage_system['uri'],
        'deviceVolumeName' => 'volume',
        'isShareable' => false,
        'name' => 'Volume1',
        'description' => 'volume test'
      }

      allow_any_instance_of(OneviewSDK::Client).to receive(:rest_post)
        .with("#{described_class::BASE_URI}/from-existing", { 'body' => data }, 500).and_return(fake_response)
      expect(@client_500).to receive(:response_handler).with(fake_response).and_return('uri' => '/rest/fake2')

      options = { 'name' => 'Volume1', 'description' => 'volume test' }
      volume = described_class.add(@client_500, @storage_system, 'volume', false, options)
      expect(volume['uri']).to eq('/rest/fake2')
    end
  end

  describe '#create_snapshot' do
    before :each do
      @snapshot_options = {
        name: 'Vol1_Snapshot1',
        description: 'New Snapshot'
      }

      @item = described_class.new(@client_500, uri: '/rest/fake')
      allow_any_instance_of(OneviewSDK::Client).to receive(:response_handler).and_return(true)
      expect(@client_500).to receive(:rest_post).with("#{@item['uri']}/snapshots", { 'body' => @snapshot_options }, @item.api_version)
    end

    it 'creates the snapshot' do
      @item.create_snapshot(@snapshot_options[:name], @snapshot_options[:description])
    end

    it 'creates the snapshot with a hash' do
      @item.create_snapshot(@snapshot_options)
    end
  end
end
