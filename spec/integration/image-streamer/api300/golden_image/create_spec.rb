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

klass = OneviewSDK::ImageStreamer::API300::GoldenImage
RSpec.describe klass, integration_i3s: true, type: CREATE, sequence: i3s_seq(klass) do
  include_context 'integration i3s api300 context'

  let(:golden_image_upload_path) { 'spec/support/vmwareesxi6_test.zip' }
  let(:golden_image_download_path) { 'spec/support/golden_image_test.zip' }
  let(:golden_image_log_path) { 'spec/support/details_gi.log' }

  describe '#create' do
    it 'creates a golden image' do
      os_volumes = OneviewSDK::ImageStreamer::API300::OsVolumes.find_by($client_i3s_300, {}).first
      build_plan = OneviewSDK::ImageStreamer::API300::BuildPlan.find_by($client_i3s_300, oeBuildPlanType: 'capture').first

      options = {
        type: 'GoldenImage',
        name: GOLDEN_IMAGE1_NAME,
        description: 'Any_Description',
        imageCapture: true
      }

      item = klass.new($client_i3s_300, options)
      item.set_os_volume(os_volumes)
      item.set_build_plan(build_plan)
      expect { item.create! }.not_to raise_error
      item.retrieve!
      expect(item['uri']).to be
      expect(item['name']).to eq(options[:name])
      expect(item['description']).to eq(options[:description])
      expect(item['osVolumeURI']).to eq(os_volumes['uri'])
      expect(item['buildPlanUri']).to eq(build_plan['uri'])
    end
  end

  describe '#add' do
    it 'adding a golden image' do
      options = { name: GOLDEN_IMAGE2_NAME, description: 'Any_Description' }
      expect { klass.add($client_i3s_300, golden_image_upload_path, options) }.not_to raise_error
      item = klass.find_by($client_i3s_300, name: GOLDEN_IMAGE2_NAME).first
      expect(item['uri']).to be
      expect(item['name']).to eq(options[:name])
      expect(item['description']).to eq(options[:description])
    end
  end

  describe '#download_details_archive' do
    it 'raises exception when uri is empty' do
      item = klass.new($client_i3s_300)
      expect { item.download_details_archive(golden_image_log_path) }.to raise_error(OneviewSDK::IncompleteResource, /Please set uri attribute/)
    end

    it 'gets details of the golden image capture logs' do
      item = klass.find_by($client_i3s_300, name: GOLDEN_IMAGE1_NAME).first
      expect { item.download_details_archive(golden_image_log_path) }.not_to raise_error
    end
  end

  describe '#download' do
    it 'raises exception when uri is empty' do
      item = klass.new($client_i3s_300)
      expect { item.download(golden_image_download_path) }.to raise_error(OneviewSDK::IncompleteResource, /Please set uri attribute/)
    end

    it 'downloads the content of the selected golden image as per the specified attributes' do
      item = klass.find_by($client_i3s_300, name: GOLDEN_IMAGE1_NAME).first
      expect { item.download(golden_image_download_path) }.not_to raise_error
    end
  end
end
