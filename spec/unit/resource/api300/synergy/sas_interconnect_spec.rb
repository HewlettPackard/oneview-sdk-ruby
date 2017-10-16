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

klass = OneviewSDK::API300::Synergy::SASInterconnect
inherited_klass = OneviewSDK::Resource

RSpec.describe klass do
  include_context 'shared context'

  it 'inherits from expected class' do
    expect(described_class).to be < inherited_klass
  end

  describe 'undefined methods' do
    before :each do
      @item = klass.new(@client_300, {})
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

  describe '#get_types' do
    before :each do
      @type = 'Synergy 12Gb SAS Connection Module'
    end

    it 'gets an interconnect type' do
      allow_any_instance_of(OneviewSDK::Client).to receive(:rest_get).with('/rest/sas-interconnect-types')
                                                                     .and_return(FakeResponse.new('members' => [{ 'name' => @type, 'uri' => '/rest/fake' }]))
      item = klass.get_type(@client_300, @type)
      expect(item['name']).to eq(@type)
    end
  end

  describe '#set_refresh_state' do
    before :each do
      @item = klass.new(@client_300, name: 'fake', uri: '/rest/fake', refreshState: 'NotRefreshing')
    end

    it 'requires a uri' do
      expect { klass.new(@client_300, {}).set_refresh_state(:state) }.to raise_error(OneviewSDK::IncompleteResource, /Please set uri/)
    end

    it 'does a PUT to /refreshState' do
      expect(@client_300).to receive(:rest_put).with(@item['uri'] + '/refreshState', 'body' => { refreshState: 'RefreshPending' })
                                               .and_return(FakeResponse.new(refreshState: 'Refreshing'))
      @item.set_refresh_state('RefreshPending')
      expect(@item['refreshState']).to eq('Refreshing')
    end
  end

  describe '#patch' do
    before :each do
      @item = klass.new(@client_300, name: 'fake', uri: '/rest/fake')
    end

    it 'requires a uri' do
      item = klass.new(@client_300, {})
      expect { item.patch('replace', '/hardResetState', 'Reset') }.to raise_error(OneviewSDK::IncompleteResource, /Please set uri/)
    end

    it 'does a reset to the appliance' do
      expect(@client_300).to receive(:rest_patch).with(@item['uri'], 'body' => [{ op: 'replace', path: '/hardResetState', value: 'Reset' }])
                                                 .and_return(FakeResponse.new([@item]))
      expect { @item.patch('replace', '/hardResetState', 'Reset') }.not_to raise_error
    end
  end
end
