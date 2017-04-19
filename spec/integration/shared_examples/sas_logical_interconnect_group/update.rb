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

RSpec.shared_examples 'SASLogInterGroupUpdateExample' do |context_name|
  include_context context_name

  subject(:item) { described_class.new(current_client, name: SAS_LOG_INT_GROUP1_NAME) }

  describe '#update' do
    it 'is able to update the resource name and set it back' do
      item.retrieve!

      expect { item.update(name: "#{SAS_LOG_INT_GROUP1_NAME}_Updated") }.not_to raise_error

      expect(item['name']).to eq("#{SAS_LOG_INT_GROUP1_NAME}_Updated")

      expect { item.update(name: SAS_LOG_INT_GROUP1_NAME) }.not_to raise_error

      expect(item['name']).to eq(SAS_LOG_INT_GROUP1_NAME)
      expect(item['uri']).to be
    end
  end
end
