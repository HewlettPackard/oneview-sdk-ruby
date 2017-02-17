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

klass = OneviewSDK::ImageStreamer::API300::ArtifactBundle
RSpec.describe klass, integration_i3s: true, type: UPDATE do
  include_context 'integration i3s api300 context'

  subject(:item) { klass.find_by($client_i3s_300, name: ARTIFACT_BUNDLE1_NAME).first }

  describe '#update' do
    it 'should throw unavailable method error' do
      expect { item.update }.to raise_error(OneviewSDK::MethodUnavailable)
    end
  end

  describe '#update_name' do
    it 'should update the name of the artifact bundle' do
      new_name = ARTIFACT_BUNDLE1_NAME + ' Updated'

      expect(item.update_name(new_name)).to eq(true)
      expect(item.retrieve!).to eq(true)
      expect(item['name']).to eq(new_name)

      # coming back to old value
      expect { item.update_name(ARTIFACT_BUNDLE1_NAME) }.not_to raise_error
    end

    context 'when update name of the read only ArtifactBundle' do
      it 'should throw error' do
        artifact_bundle = klass.new($client_i3s_300, name: ARTIFACT_BUNDLE2_NAME)
        new_name = ARTIFACT_BUNDLE2_NAME + ' Updated'

        expect(artifact_bundle.retrieve!).to eq(true)
        expect { artifact_bundle.update_name(new_name) }.to raise_error(OneviewSDK::RequestError, /The artifact bundle is not allowed to be modified/)
        expect(artifact_bundle.retrieve!).to eq(true)
        expect(artifact_bundle['name']).to eq(ARTIFACT_BUNDLE2_NAME) # it was did not changed
      end
    end
  end
end
