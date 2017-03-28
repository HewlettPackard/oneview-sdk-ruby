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

klass = OneviewSDK::API500::Synergy::Scope
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  include_context 'integration api500 context'

  describe '#create' do
    it 'should create scope' do
      attrs = {
        name: 'Scope 1',
        description: 'Sample Scope description'
      }
      item = described_class.new($client_500_synergy, attrs)

      expect { item.create }.not_to raise_error
      expect(item.retrieve!).to eq(true)
      expect(item['uri']).to be
      expect(item['type']).to eq('ScopeV2')
      expect(item['name']).to eq('Scope 1')
      expect(item['description']).to eq('Sample Scope description')

      scope = klass.new($client_500_synergy, name: 'Scope 2')
      expect { scope.create }.to_not raise_error
    end
  end
end
