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

RSpec.shared_examples 'UserCreateExample' do |context_name|
  include_context context_name

  let(:resource_attributes) do
    {
      userName: USER_NAME,
      password: 'secret123',
      emailAddress: 'test_user@hpe.com',
      fullName: 'Test User',
      roles: ['Read only']
    }
  end

  describe '#create' do
    it 'can create resources' do
      item = described_class.new(current_client, resource_attributes)

      expect { item.create }.to_not raise_error
      expect(item[:userName]).to eq(USER_NAME)
      expect(item[:emailAddress]).to eq('test_user@hpe.com')
      expect(item[:fullName]).to eq('Test User')
      expect(item[:roles]).to eq(['Read only'])
    end
  end

  describe '#create!' do
    it 'should retrieve, delete and create the resource' do
      item = described_class.new(current_client, resource_attributes)
      expect { item.create! }.not_to raise_error
      expect(item.retrieve!).to eq(true)
      list = described_class.find_by(current_client, userName: USER_NAME)
      expect(list.size).to eq(1)
    end
  end

  describe '#validate_user_name' do
    it 'validates an existing user with an existing user name' do
      expect(described_class.validate_user_name(current_client, USER_NAME)).to eq(true)
    end

    it 'validates an existing user with a non-existent user name' do
      expect(described_class.validate_user_name(current_client, 'any')).to eq(false)
    end
  end

  describe '#validate_full_name' do
    it 'validates an existing user with a full name' do
      expect(described_class.validate_full_name(current_client, FULL_NAME)).to eq(true)
    end

    it 'validates an existing user with a non-existent full name' do
      expect(described_class.validate_full_name(current_client, 'any')).to eq(false)
    end
  end
end
