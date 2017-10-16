# (C) Copyright 2016 Hewlett Packard Enterprise Development LP
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

RSpec.describe OneviewSDK::API300::C7000::UnmanagedDevice do
  include_context 'shared context'

  it 'inherits from API200' do
    expect(described_class).to be < OneviewSDK::API200::UnmanagedDevice
  end

  describe '#self.get_devices' do
    it 'Get unmanaged devices' do
      expect(@client_300).to receive(:rest_get).with('/rest/unmanaged-devices').and_return(FakeResponse.new({}))
      expect { OneviewSDK::API300::C7000::UnmanagedDevice.get_devices(@client_300) }.not_to raise_error
    end
  end

  describe '#add' do
    it 'Should support add' do
      device = OneviewSDK::API300::C7000::UnmanagedDevice.new(@client_300, name: 'UnmanagedDevice_1')
      expect(@client_300).to receive(:rest_post).with('/rest/unmanaged-devices', { 'body' => { 'name' => 'UnmanagedDevice_1' } }, 300)
                                                .and_return(FakeResponse.new({}))
      expect { device.add }.not_to raise_error
    end
  end

  describe '#remove' do
    it 'Should support remove' do
      device = OneviewSDK::API300::C7000::UnmanagedDevice.new(@client_300, uri: '/rest/fake')
      expect(@client_300).to receive(:rest_delete).with('/rest/fake', {}, 300).and_return(FakeResponse.new({}))
      expect { device.remove }.not_to raise_error
    end
  end

  describe '#create' do
    it 'Should raise error if used' do
      device = OneviewSDK::API300::C7000::UnmanagedDevice.new(@client_300)
      expect { device.create }.to raise_error(OneviewSDK::MethodUnavailable)
    end
  end

  describe '#delete' do
    it 'Should raise error if used' do
      device = OneviewSDK::API300::C7000::UnmanagedDevice.new(@client_300)
      expect { device.delete }.to raise_error(OneviewSDK::MethodUnavailable)
    end
  end

  describe '#environmentalConfiguration' do
    it 'requires a uri' do
      expect { OneviewSDK::API300::C7000::UnmanagedDevice.new(@client_300).environmental_configuration }
        .to raise_error(OneviewSDK::IncompleteResource, /Please set uri/)
    end

    it 'gets uri/environmentalConfiguration' do
      item = OneviewSDK::API300::C7000::UnmanagedDevice.new(@client_300, uri: '/rest/fake')
      expect(@client_300).to receive(:rest_get).with('/rest/fake/environmentalConfiguration').and_return(FakeResponse.new({}))
      expect { item.environmental_configuration }.not_to raise_error
    end
  end
end
