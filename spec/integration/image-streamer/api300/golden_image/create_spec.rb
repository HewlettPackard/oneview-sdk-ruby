# (C) Copyright 2016 Hewlett Packard Enterprise Development LP
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

klass = OneviewSDK::ImageStreamer::API300::GoldenImage
RSpec.describe klass, integration_i3s: true, type: CREATE do
  include_context 'integration i3s api300 context'

  let(:file_path) { 'spec/support/vmwareesxi6_test.zip' }

  # describe '#create' do
  #   it 'creates a golden image' do
  #     os_volumes = OneviewSDK::ImageStreamer::API300::OsVolumes.find_by($client_i3s_300, {}).first
  #     build_plan = OneviewSDK::ImageStreamer::API300::BuildPlan.find_by($client_i3s_300, oeBuildPlanType: 'capture').first
  #
  #     options = {
  #       type: 'GoldenImage',
  #       name: 'Golden_Image_1',
  #       description: 'Any_Description',
  #       imageCapture: true,
  #       osVolumeURI: os_volumes['uri'],
  #       buildPlanUri: build_plan['uri']
  #     }
  #
  #     item = klass.new($client_i3s_300, options)
  #     expect { item.create! }.not_to raise_error
  #     item.retrieve!
  #     expect(item['uri']).to be
  #     expect(item['name']).to eq(options[:name])
  #     expect(item['description']).to eq(options[:description])
  #     expect(item['osVolumeURI']).to eq(options[:osVolumeURI])
  #     expect(item['buildPlanUri']).to eq(options[:buildPlanUri])
  #   end
  # end

  # describe '#add' do
  #   it 'adding a golden image' do
  #     options = { name: 'Golden_Image_2', description: 'Any_Description' }
  #     expect { klass.add($client_i3s_300, 'spec/support/vmwareesxi6_test.zip', options) }.not_to raise_error
  #     item = klass.find_by($client_i3s_300, name: 'Golden_Image_2').first
  #     expect(item['uri']).to be
  #     expect(item['name']).to eq(options[:name])
  #     expect(item['description']).to eq(options[:description])
  #   end
  # end

  # describe '#get_details_archive' do
  #   it 'gets details of the golden image capture logs' do
  #     item = klass.find_by($client_i3s_300, {}).first
  #     expect { item.get_details_archive('spec/support/details_gi.log') }.not_to raise_error
  #   end
  # end

  describe '#download' do
    it 'downloads the content of the selected golden image as per the specified attributes' do
      item = klass.find_by($client_i3s_300, {}).first
      expect { item.download('spec/support/golden_image_test.zip') }.not_to raise_error
    end
  end
end
