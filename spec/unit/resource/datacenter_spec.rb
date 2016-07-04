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

RSpec.describe OneviewSDK::Datacenter do
  include_context 'shared context'

  describe '#initialize' do
    it 'sets the defaults correctly' do
      datacenter = OneviewSDK::Datacenter.new(@client)
      expect(datacenter['contents']).to eq([])
    end
  end

  describe '#add_rack' do
    before :each do
      @datacenter = OneviewSDK::Datacenter.new(@client)
    end

    it 'Add one rack without rotation' do
      rack1 = Hash.new('uri' => '/rest/fake/rack1')
      @datacenter.add_rack(rack1, 5000, 5000)
      expect(@datacenter['contents'][0]['resourceUri']).to eq(rack1['uri'])
    end

    it 'Add one rack with rotation included' do
      rack1 = Hash.new('uri' => '/rest/fake/rack1')
      @datacenter.add_rack(rack1, 5000, 5000, 100)
      expect(@datacenter['contents'][0]['resourceUri']).to eq(rack1['uri'])
    end

    it 'Add multiple racks' do
      rack1 = Hash.new('uri' => '/rest/fake/rack1')
      rack2 = Hash.new('uri' => '/rest/fake/rack2')
      @datacenter.add_rack(rack1, 500, 1000)
      @datacenter.add_rack(rack2, 100, 1000)
      expect(@datacenter['contents'][0]['resourceUri']).to eq(rack1['uri'])
      expect(@datacenter['contents'][1]['resourceUri']).to eq(rack2['uri'])
    end
  end

  describe '#remove_rack' do
    before :each do
      @datacenter = OneviewSDK::Datacenter.new(@client)
    end

    it 'Remove rack from empty list' do
      rack1 = Hash.new('uri' => '/rest/fake/rack1')
      expect { @datacenter.remove_rack(rack1) }.not_to raise_error
    end

    it 'Remove only one rack' do
      rack1 = Hash.new('uri' => '/rest/fake/rack1')
      rack2 = Hash.new('uri' => '/rest/fake/rack2')
      @datacenter.add_rack(rack1, 100, 100)
      @datacenter.add_rack(rack2, 200, 200)
      @datacenter.remove_rack(rack1)
      results = @datacenter['contents'].map { |rack| rack['resourceUri'] }
      expect(results).not_to include(rack1['uri'])
      expect(results).to include(rack2['uri'])
    end
  end
end
