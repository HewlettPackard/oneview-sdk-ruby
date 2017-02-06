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

klass = OneviewSDK::ImageStreamer::API300::OSVolumes
RSpec.describe klass, integration_i3s: true, type: CREATE do
  include_context 'integration i3s api300 context'

  describe '#create' do
    it 'raises MethodUnavailable' do
      item = klass.new($client_i3s_300)
      expect { item.create }.to raise_error(/The method #create is unavailable for this resource/)
    end
  end

  describe '#get_details_archives' do
    it 'raises exception when uri is empty' do
      item = klass.new($client_i3s_300)
      expect { item.get_details_archive }.to raise_error(OneviewSDK::IncompleteResource, /Please set uri attribute/)
    end

    it 'gets the details of the archived OS volume' do
      item = klass.find_by($client_i3s_300, {}).first
      expect(item['uri']).to be
      expect { item.get_details_archive }.not_to raise_error
    end
  end
end
