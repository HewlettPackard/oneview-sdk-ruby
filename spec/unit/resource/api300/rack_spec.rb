# (C) Copyright 2016 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.

require 'spec_helper'

RSpec.describe OneviewSDK::API300::Rack do
  include_context 'shared context'

  it 'inherits from API200' do
    expect(described_class).to be < OneviewSDK::API200::Rack
  end

  describe '#initialize' do
    it 'sets the defaults correctly' do
      rack = OneviewSDK::API300::Rack.new(@client_300)
      expect(rack['rackMounts']).to eq([])
    end
  end

  describe '#add' do
    it 'Should support add' do
      rack = OneviewSDK::API300::Rack.new(@client_300, uri: '/rest/racks')
      expect(@client_300).to receive(:rest_post).with('/rest/racks', { 'body' => { 'uri' => '/rest/racks', 'rackMounts' => [] } }, 300)
        .and_return(FakeResponse.new({}))
      rack.add
    end
  end

  describe '#remove' do
    it 'Should support remove' do
      rack = OneviewSDK::API300::Rack.new(@client_300, uri: '/rest/fake')
      expect(@client_300).to receive(:rest_delete).with('/rest/fake', {}, 300).and_return(FakeResponse.new({}))
      rack.remove
    end
  end

  describe '#add_rack_resource' do
    before :each do
      @rack = OneviewSDK::API300::Rack.new(@client_300)
    end

    it 'Add one resource' do
      enclosure1 = OneviewSDK::Enclosure.new(@client_300, uri: '/rest/enclosures/fake')
      @rack.add_rack_resource(enclosure1)
      expect(@rack['rackMounts'].first['mountUri']).to eq(enclosure1['uri'])
      expect(@rack['rackMounts'].first['location']).to eq('CenterFront')
    end

    it 'Add one resource with options' do
      enclosure1 = OneviewSDK::Enclosure.new(@client_300, uri: '/rest/enclosures/fake')
      @rack.add_rack_resource(enclosure1, location: 'Left', topUSlot: 20, uHeight: 10)
      expect(@rack['rackMounts'].first['mountUri']).to eq(enclosure1['uri'])
      expect(@rack['rackMounts'].first['location']).to eq('Left')
      expect(@rack['rackMounts'].first['topUSlot']).to eq(20)
      expect(@rack['rackMounts'].first['uHeight']).to eq(10)
    end

    it 'Add existing resource and update attributes' do
      enclosure1 = OneviewSDK::Enclosure.new(@client_300, uri: '/rest/enclosures/fake')
      @rack.add_rack_resource(enclosure1, location: 'Left', topUSlot: 20, uHeight: 10)
      expect(@rack['rackMounts'].first['mountUri']).to eq(enclosure1['uri'])
      expect(@rack['rackMounts'].first['location']).to eq('Left')
      expect(@rack['rackMounts'].first['topUSlot']).to eq(20)
      expect(@rack['rackMounts'].first['uHeight']).to eq(10)
      mount_count = @rack['rackMounts'].size

      @rack.add_rack_resource(enclosure1, topUSlot: 5, uHeight: 11)
      expect(@rack['rackMounts'].first['mountUri']).to eq(enclosure1['uri'])
      expect(@rack['rackMounts'].first['location']).to eq('Left')
      expect(@rack['rackMounts'].first['topUSlot']).to eq(5)
      expect(@rack['rackMounts'].first['uHeight']).to eq(11)
      expect(@rack['rackMounts'].size).to eq(mount_count)

    end

    it 'Add multiple resources' do
      enclosure1 = OneviewSDK::Enclosure.new(@client_300, uri: '/rest/enclosures/fake1')
      enclosure2 = OneviewSDK::Enclosure.new(@client_300, uri: '/rest/enclosures/fake2')
      @rack.add_rack_resource(enclosure1)
      @rack.add_rack_resource(enclosure2)

      # Retrieve only the uris for the mounted resources
      mounts = @rack['rackMounts'].map { |resource| resource['mountUri'] }
      expect(mounts).to include(enclosure1['uri'])
      expect(mounts).to include(enclosure2['uri'])
    end
  end

  describe '#remove_rack_resource' do
    before :each do
      @rack = OneviewSDK::API300::Rack.new(@client_300)
    end

    it 'Remove one resource' do
      enclosure1 = OneviewSDK::Enclosure.new(@client_300, uri: '/rest/enclosures/fake')
      @rack.add_rack_resource(enclosure1)
    end

    it 'Remove only one resource' do
      enclosure1 = OneviewSDK::Enclosure.new(@client_300, uri: '/rest/enclosures/fake1')
      enclosure2 = OneviewSDK::Enclosure.new(@client_300, uri: '/rest/enclosures/fake2')
      @rack.add_rack_resource(enclosure1)
      @rack.add_rack_resource(enclosure2)
      @rack.remove_rack_resource(enclosure2)

      # Retrieve only the uris for the mounted resources
      mounts = @rack['rackMounts'].map { |resource| resource['mountUri'] }
      expect(mounts).to include(enclosure1['uri'])
      expect(mounts).not_to include(enclosure2['uri'])
    end
  end

  describe '#create' do
    it 'Should raise error if used' do
      rack = OneviewSDK::API300::Rack.new(@client_300)
      expect { rack.create }.to raise_error(/The method #create is unavailable for this resource/)
    end
  end

  describe '#delete' do
    it 'Should raise error if used' do
      rack = OneviewSDK::API300::Rack.new(@client_300)
      expect { rack.delete }.to raise_error(/The method #delete is unavailable for this resource/)
    end
  end

  describe '#get_device_topology' do
    it 'Device topology' do
      rack = OneviewSDK::API300::Rack.new(@client_300, uri: '/rest/fake')
      expect(@client_300).to receive(:rest_get).with('/rest/fake/deviceTopology').and_return(FakeResponse.new({}))
      rack.get_device_topology
    end
  end
end
