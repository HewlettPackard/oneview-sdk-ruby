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

klass = OneviewSDK::API300::Synergy::SASLogicalInterconnectGroup
inherited_klass = OneviewSDK::Resource
extra_klass1 = OneviewSDK::API300::Synergy::SASInterconnect

RSpec.describe klass do
  include_context 'shared context'

  it 'inherits from expected class' do
    expect(described_class).to be < inherited_klass
  end

  describe '#initialize' do
    it 'sets the defaults correctly' do
      item = klass.new(@client_300)
      expect(item['enclosureType']).to eq('SY12000')
      expect(item['enclosureIndexes']).to eq([1])
      expect(item['state']).to eq('Active')
      expect(item['type']).to eq('sas-logical-interconnect-group')
    end
  end

  describe '#add_interconnect' do
    before :each do
      @item = klass.new(@client_300)
      @type = 'Synergy 12Gb SAS Connection Module'
    end

    it 'adds a valid interconnect type' do
      allow(extra_klass1).to receive(:get_type).with(anything, @type)
        .and_return('uri' => '/rest/fake')
      @item.add_interconnect(1, @type)
      @item.add_interconnect(4, @type)
      expect(@item['interconnectMapTemplate']['interconnectMapEntryTemplates'][0]['permittedInterconnectTypeUri'])
        .to eq('/rest/fake')
    end

    it 'raises an error if the interconnect is not found' do
      expect(extra_klass1).to receive(:get_type).with(@client_300, @type)
        .and_return([])
      expect(extra_klass1).to receive(:get_types).and_return([{ 'name' => '1' }, { 'name' => '2' }])
      expect { @item.add_interconnect(1, @type) }.to raise_error(/not found!/)
    end
  end
end
