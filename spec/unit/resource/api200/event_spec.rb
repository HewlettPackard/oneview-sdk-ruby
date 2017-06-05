# (C) Copyright 2017 Hewlett Packard Enterprise Development LP
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

RSpec.describe OneviewSDK::Event do
  include_context 'shared context'

  describe '#initialize' do
    it 'sets the defaults correctly' do
      datacenter = described_class.new(@client_200)
      expect(datacenter['type']).to eq('EventResourceV3')
    end
  end

  describe '#update' do
    it 'should raise MethodUnavailable' do
      item = described_class.new(@client_200)
      expect { item.update }.to raise_error(/The method #update is unavailable for this resource/)
    end
  end

  describe '#delete' do
    it 'should raise MethodUnavailable' do
      item = described_class.new(@client_200)
      expect { item.delete }.to raise_error(/The method #delete is unavailable for this resource/)
    end
  end
end
