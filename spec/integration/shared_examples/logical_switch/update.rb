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

RSpec.shared_examples 'LogicalSwitchUpdateExample' do |context_name, options|
  include_context context_name

  subject(:item) { described_class.find_by(current_client, name: LOG_SWI_NAME).first }

  describe '#get_internal_link_sets', if: options['execute_internal_links_sets'] do
    it 'gets the internal link sets' do
      expect { described_class.get_internal_link_sets(current_client) }.not_to raise_error
    end
  end

  describe '#refresh_state', if: options['execute_refresh'] do
    it 'should reclaims the top-of-rack switches in a logical switch' do
      expect { item.refresh_state }.to_not raise_error
    end
  end
end
