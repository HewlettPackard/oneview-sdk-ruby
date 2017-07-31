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

RSpec.shared_examples 'LogicalSwitchGroupDeleteExample' do |context_name|
  include_context context_name

  describe '#delete' do
    it 'removes all the Logical Switch groups' do
      item = described_class.new(current_client, name: LOG_SWI_GROUP_NAME)
      item.retrieve!
      expect { item.delete }.to_not raise_error
      item = described_class.find_by(current_client, name: LOG_SWI_GROUP_NAME)
      expect(item).to be_empty
    end
  end
end
