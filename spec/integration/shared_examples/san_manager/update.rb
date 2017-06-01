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

RSpec.shared_examples 'SANManagerUpdateExample' do |context_name|
  include_context context_name

  subject(:item) { described_class.find_by(current_client, name: san_manager_ip).first }

  describe '#update' do
    it 'refresh a SAN Device Manager' do
      expect { item.update(refreshState: 'RefreshPending') }.not_to raise_error
    end

    it 'Update hostname and credentials' do
      expect { item.update(connectionInfo: connection_info) }.not_to raise_error
    end

    it 'Update invalid field' do
      expect { item.update(name: 'SANManager_01') }.to raise_error(OneviewSDK::BadRequest)
    end
  end
end
