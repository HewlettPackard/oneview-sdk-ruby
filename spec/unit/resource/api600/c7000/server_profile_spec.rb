require 'spec_helper'

RSpec.describe OneviewSDK::API600::C7000::ServerProfile do
  include_context 'shared context'

  it 'inherits from API500' do
    expect(described_class).to be < OneviewSDK::API500::C7000::ServerProfile
  end

  describe '#initialize' do
    it 'sets the type correctly' do
      item = described_class.new(@client_600, name: 'server_profile')
      expect(item[:type]).to eq('ServerProfileV8')
    end
  end

  describe '#add_connection' do
    before :each do
      @item = described_class.new(@client_500, name: 'server_profile')
      @item['connectionSettings'] = {}
      @item['connectionSettings']['connections'] = []
      @network = OneviewSDK::API500::C7000::EthernetNetwork.new(@client_500, name: 'unit_ethernet_network', uri: 'rest/fake/ethernet-networks/unit')
    end

    it 'adds simple connection' do
      expect { @item.add_connection(@network, 'name' => 'unit_net') }.to_not raise_error
      expect(@item['connectionSettings']['connections']).to be
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
        expect(connection['name']).to match(/unit_net_/)
      end
    end

    describe '#remove_connection' do
      before :each do
        @item = described_class.new(@client_500, name: 'server_profile')
        @item['connectionSettings'] = {}
        @item['connectionSettings']['connections'] = []
        @network = OneviewSDK::EthernetNetwork.new(@client_500, name: 'unit_ethernet_network', uri: 'rest/fake/ethernet-networks/unit')
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

end
