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

RSpec.describe OneviewSDK::ImageStreamer::API300::ArtifactBundle, integration_i3s: true, type: DELETE do
  include_context 'integration i3s api300 context'

  describe '#delete' do
    it 'should remove the artifact bundle' do
      item = described_class.new($client_i3s_300, name: ARTIFACT_BUNDLE1_NAME)
      item2 = described_class.new($client_i3s_300, name: ARTIFACT_BUNDLE2_NAME)
      expect(item.retrieve!).to eq(true)
      expect(item2.retrieve!).to eq(true)
      expect { item.delete }.not_to raise_error
      expect { item2.delete }.not_to raise_error
      expect(item.retrieve!).to eq(false)
      expect(item2.retrieve!).to eq(false)
    end
  end
end
