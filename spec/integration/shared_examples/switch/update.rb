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

RSpec.shared_examples 'SwitchUpdateExample' do |context_name|
  include_context context_name

  describe '#update' do
    it 'raises MethodUnavailable' do
      item = described_class.new(current_client, {})
      expect { item.update }.to raise_error(/The method #update is unavailable for this resource/)
    end
  end

  describe '#refresh' do
    it 'raises MethodUnavailable' do
      item = described_class.new(current_client, {})
      expect { item.refresh }.to raise_error(/The method #refresh is unavailable for this resource/)
    end
  end
end
