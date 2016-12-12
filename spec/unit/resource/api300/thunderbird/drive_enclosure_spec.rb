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

RSpec.describe OneviewSDK::API300::Synergy::DriveEnclosure do
  include_context 'shared context'

  it 'inherits from Resource' do
    expect(described_class).to be < OneviewSDK::API300::Synergy::Resource
  end

  describe 'undefined methods' do
    before :each do
      @item = OneviewSDK::API300::Synergy::DriveEnclosure.new(@client_300, uri: '/rest/drive-enclosure')
    end

    it 'does not allow the create action' do
      expect { @item.create }.to raise_error(/The method #create is unavailable for this resource/)
    end

    it 'does not allow the update action' do
      expect { @item.update }.to raise_error(/The method #update is unavailable for this resource/)
    end

    it 'does not allow the delete action' do
      expect { @item.delete }.to raise_error(/The method #delete is unavailable for this resource/)
    end
  end

  describe '#get_port_map' do
    it 'should retrieve the port map information' do
      item = OneviewSDK::API300::Synergy::DriveEnclosure.new(@client_300, uri: '/rest/drive-enclosure')
      expect(@client_300).to receive(:rest_get).with('/rest/drive-enclosure/port-map').and_return(FakeResponse.new('Blah'))
      expect(item.get_port_map).to eq('Blah')
    end
  end

  describe '#set_refresh_state' do
    it 'should set the drive enclosure refresh state' do
      item = OneviewSDK::API300::Synergy::DriveEnclosure.new(@client_300, uri: '/rest/drive-enclosure')
      expect(@client_300).to receive(:rest_put).with(
        '/rest/drive-enclosure/refreshState',
        'body' => { refreshState: 'RefreshPending' }
      ).and_return(FakeResponse.new({}))
      item.set_refresh_state('RefreshPending')
    end
  end

  describe '#patch' do
    it 'should send a patch request to the drive enclosure' do
      item = OneviewSDK::API300::Synergy::DriveEnclosure.new(@client_300, uri: '/rest/drive-enclosure')
      patch_opt = { op: 'replace', path: '/powerState', value: 'On' }
      expect(@client_300).to receive(:rest_patch).with(
        '/rest/drive-enclosure',
        'body' => [patch_opt]
      ).and_return(FakeResponse.new({}))
      item.patch('replace', '/powerState', 'On')
    end
  end
end
