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

RSpec.describe OneviewSDK::API300::Synergy::OSDeploymentPlan do
  include_context 'shared context'

  it 'BASE_URI should be the correct URI' do
    expect(described_class::BASE_URI).to eq('/rest/os-deployment-plans/')
  end

  it 'inherits from Resource' do
    expect(described_class).to be < OneviewSDK::API300::Synergy::Resource
  end

  describe '#create' do
    it 'should throw unavailable method error' do
      item = described_class.new(@client_300)
      expect { item.create }.to raise_error(/The method #create is unavailable for this resource/)
    end
  end

  describe '#update' do
    it 'should throw unavailable method error' do
      item = described_class.new(@client_300)
      expect { item.update }.to raise_error(/The method #update is unavailable for this resource/)
    end
  end

  describe '#delete' do
    it 'should throw unavailable method error' do
      item = described_class.new(@client_300)
      expect { item.delete }.to raise_error(/The method #delete is unavailable for this resource/)
    end
  end
end
