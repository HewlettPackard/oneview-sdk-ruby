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

RSpec.shared_examples 'UserUpdateExample' do |context_name|
  include_context context_name

  subject(:item) { described_class.find_by(current_client, userName: USER_NAME).first }

  describe '#update' do
    it 'can update resources' do
      item.set_all(
        password: 'secret456',
        emailAddress: 'new_email@hpe.com',
        fullName: 'New Name',
        roles: ['Network administrator', 'Storage administrator']
      )
      expect { item.update }.not_to raise_error
      expect(item['emailAddress']).to eq('new_email@hpe.com')
      expect(item['fullName']).to eq('New Name')
      expect(item['roles']).to eq(['Network administrator', 'Storage administrator'])
    end
  end
end
