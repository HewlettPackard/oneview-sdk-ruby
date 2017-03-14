# (C) Copyright 2017 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License.

require 'spec_helper'

klass = OneviewSDK::API300::Synergy::OSDeploymentPlan
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  include_context 'integration api300 context'

  describe '#create' do
    it 'should throw method unavailable exception' do
      item = klass.new($client_300)
      expect { item.create }.to raise_error(OneviewSDK::MethodUnavailable)
    end
  end

  describe '::get_all' do
    it 'should get all OS Deployment Plans' do
      items = klass.get_all($client_300)
      expect(items).not_to be_empty
      expect(items.first.class).to eq(OneviewSDK::API300::Synergy::OSDeploymentPlan)
    end
  end

  describe '::find_by' do
    it 'should get specific OS Deployment Plan' do
      item = klass.get_all($client_300).first
      items_searched = klass.find_by($client_300, name: item['name'])
      expect(items_searched.size).to eq(1)
      expect(items_searched.first['uri']).to eq(item['uri'])
    end

    context 'when there are not items for the paramater passed' do
      it 'should return an empty list' do
        items_searched = klass.find_by($client_300, name: 'some wrong name')
        expect(items_searched).to be_empty
      end
    end
  end

  describe '#retrieve!' do
    it 'should get specific OS Deployment Plan by URI' do
      item = klass.get_all($client_300).first
      item_retrieved = klass.new($client_300, uri: item['uri'])
      expect(item_retrieved.retrieve!).to eq(true)
      expect(item_retrieved['name']).to eq(item['name'])
    end
  end
end
