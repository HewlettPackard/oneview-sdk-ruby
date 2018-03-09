require 'spec_helper'

RSpec.describe OneviewSDK::API600::C7000::ServerProfileTemplate do
  include_context 'shared context'

  it 'inherits from API500' do
    expect(described_class).to be < OneviewSDK::API500::C7000::ServerProfileTemplate
  end

  describe '#initialize' do
    it 'sets the type correctly' do
      item = described_class.new(@client_600, name: 'server_profile_template')
      expect(item[:type]).to eq('ServerProfileTemplateV3')
    end
  end

  describe '#add_connection' do
    before :each do
      @item = described_class.new(@client_600, name: 'server_profile_template')
      @item['connectionSettings'] = {}
      @item['connectionSettings']['connections'] = []
      @network = OneviewSDK::API600::C7000::EthernetNetwork.new(@client_600, name: 'unit_ethernet_network', uri: 'rest/fake/ethernet-networks/unit')
    end

    it 'adds simple connection' do
      expect { @item.add_connection(@network, 'name' => 'unit_net') }.to_not raise_error
      expect(@item['connectionSettings']['connections']).to be
      expect(@item['connectionSettings']['connections'].first['id']).to eq(0)
      expect(@item['connectionSettings']['connections'].first['networkUri']).to eq('rest/fake/ethernet-networks/unit')
    end

    it 'adds multiple connections' do
      base_uri = @network['uri']
      1.upto(4) do |count|
        @network['uri'] = "#{@network['uri']}_#{count}"
        expect { @item.add_connection(@network, 'name' => "unit_net_#{count}") }.to_not raise_error
        @network['uri'] = base_uri
      end
      @item['connectionSettings']['connections'].each do |connection|
        expect(connection['id']).to eq(0)
        expect(connection['name']).to match(/unit_net_/)
      end
    end

    describe '#remove_connection' do
      before :each do
        @item = described_class.new(@client_600, name: 'server_profile_template')
        @item['connectionSettings'] = {}
        @item['connectionSettings']['connections'] = []
        @network = OneviewSDK::EthernetNetwork.new(@client_600, name: 'unit_ethernet_network', uri: 'rest/fake/ethernet-networks/unit')
        base_uri = @network['uri']
        1.upto(5) do |count|
          @network['uri'] = "#{@network['uri']}_#{count}"
          @item.add_connection(@network, 'name' => "unit_con_#{count}")
          @network['uri'] = base_uri
        end
      end

      it 'removes a connection' do
        removed_connection = @item.remove_connection('unit_con_2')
        expect(removed_connection['name']).to eq('unit_con_2')
        expect(removed_connection['networkUri']).to eq("#{@network['uri']}_2")
        @item['connectionSettings']['connections'].each do |connection|
          expect(connection['name']).to_not eq(removed_connection['name'])
        end
      end

      it 'removes all connections' do
        1.upto(5) do |count|
          removed_connection = @item.remove_connection("unit_con_#{count}")
          expect(removed_connection['name']).to eq("unit_con_#{count}")
          expect(removed_connection['networkUri']).to eq("#{@network['uri']}_#{count}")
          @item['connectionSettings']['connections'].each do |connection|
            expect(connection['name']).to_not eq(removed_connection['name'])
          end
        end
        expect(@item['connectionSettings']['connections']).to be_empty
      end

      it 'returns nil if no connection set' do
        @item.data.delete('connections')
        expect(@item.remove_connection('fake')).not_to be
      end

      it 'returns nil if connection does not exists' do
        expect(@item.remove_connection('fake')).not_to be
      end
    end
  end

  describe '#create_volume_with_attachment' do
    let(:storage_pool_class) { OneviewSDK::API600::C7000::StoragePool }
    let(:storage_pool) { storage_pool_class.new(@client_600, uri: 'fake/storage-pool') }

    before :each do
      @item = described_class.new(@client_600, name: 'server_profile_template')
    end

    it 'raises an exception when storage pool not found' do
      allow_any_instance_of(storage_pool_class).to receive(:retrieve!).and_return(false)
      expect { @item.create_volume_with_attachment(storage_pool, {}) }.to raise_error(/Storage Pool not found/)
    end

    it 'can call #create_volume_with_attachment and generate the data required for a new Volume with attachment' do
      volume_options = {
        name: 'Volume Test',
        description: 'Volume store serv',
        size: 1024 * 1024 * 1024,
        provisioningType: 'Thin',
        isShareable: false
      }

      allow_any_instance_of(storage_pool_class).to receive(:retrieve!).and_return(true)
      @item.create_volume_with_attachment(storage_pool, volume_options)
      expect(@item['sanStorage']['volumeAttachments'].size).to eq(1)
      va = @item['sanStorage']['volumeAttachments'].first
      expect(va['volumeUri']).not_to be
      expect(va['volumeStorageSystemUri']).not_to be
      expect(va['volumeStoragePoolUri']).to eq('fake/storage-pool')
      expect(va['volumeShareable']).to eq(false)
      expect(va['volumeProvisionedCapacityBytes']).to eq(1024 * 1024 * 1024)
      expect(va['volumeProvisionType']).to eq('Thin')
    end
  end
end
