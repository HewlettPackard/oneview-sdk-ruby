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
RSpec.describe klass, integration_i3s: true, type: CREATE, sequence: i3s_seq(klass) do
  include_context 'integration i3s api300 context'

  let(:deployment_group) { OneviewSDK::ImageStreamer::API300::DeploymentGroup.get_all($client_i3s_300).first }
  let(:deployment_plan) { OneviewSDK::ImageStreamer::API300::DeploymentPlan.get_all($client_i3s_300).first }
  let(:plan_script) { OneviewSDK::ImageStreamer::API300::PlanScript.get_all($client_i3s_300).first }

  before(:all) do
    @artifact_bundle_file_path = Tempfile.new(['artifact_bundle', '.zip']).path
    @backup_bundle_file_path = Tempfile.new(['backup_bundle', '.zip']).path
  end

  describe '#create' do
    it 'should create a artifact bundle' do
      options = {
        name: ARTIFACT_BUNDLE1_NAME,
        description: 'Description of ArtifactBundle'
      }
      item = klass.new($client_i3s_300, options)
      item.add_deployment_plan(deployment_plan, false)

      expect { item.create! }.not_to raise_error
      expect(item.retrieve!).to eq(true)
      expect(item['uri']).to be
      expect(item['name']).to eq(options[:name])
      expect(item['description']).to eq(options[:description])
      expect(item['deploymentPlans'].size).to eq(1)

      # creating the read only artifact bundle
      item = klass.new($client_i3s_300, options)
      item['name'] = ARTIFACT_BUNDLE2_NAME
      item.add_plan_script(plan_script)
      expect { item.create! }.not_to raise_error
      expect(item['planScripts'].size).to eq(1)
    end
  end

  describe '#download' do
    it 'should download the artifact bundle' do
      created_item = OneviewSDK::ImageStreamer::API300::ArtifactBundle.find_by($client_i3s_300, name: ARTIFACT_BUNDLE2_NAME).first
      expect { created_item.download(@artifact_bundle_file_path) }.not_to raise_error
      expect(File.exist?(@artifact_bundle_file_path)).to eq(true)
    end
  end

  describe '::create_from_file' do
    it 'should create a artifact bundle' do
      item = OneviewSDK::ImageStreamer::API300::ArtifactBundle.find_by($client_i3s_300, name: ARTIFACT_BUNDLE2_NAME).first
      item.delete

      created_item = klass.create_from_file($client_i3s_300, @artifact_bundle_file_path, ARTIFACT_BUNDLE2_NAME)
      item = OneviewSDK::ImageStreamer::API300::ArtifactBundle.find_by($client_i3s_300, name: ARTIFACT_BUNDLE2_NAME).first

      expect(created_item).to be
      expect(created_item['status']).to eq('OK')
      expect(created_item['name']).to eq(ARTIFACT_BUNDLE2_NAME)
      expect(created_item['planScripts'].size).to eq(1)

      expect(item).to be
      expect(item['name']).to eq(ARTIFACT_BUNDLE2_NAME)
      expect(item['planScripts'].size).to eq(1)
    end
  end

  describe '#extract' do
    it 'should extract the selected artifact bundle and should create the artifacts on the appliance' do
      item = klass.find_by($client_i3s_300, name: ARTIFACT_BUNDLE2_NAME).first
      expect { item.extract }.not_to raise_error
    end
  end

  describe '::create_backup' do
    it 'should create a backup with all the artifacts present on the appliance' do
      expect { klass.create_backup($client_i3s_300, deployment_group) }.not_to raise_error
    end
  end

  describe '::get_backups' do
    it 'should get the backup created' do
      result = klass.get_backups($client_i3s_300)
      expect(result).to be_instance_of(Array)
      expect(result.size).to eq(1)
    end
  end

  describe '::download_backup' do
    it 'should download a backup file' do
      artifact_bundle_backup = klass.get_backups($client_i3s_300).first
      expect { klass.download_backup($client_i3s_300, @backup_bundle_file_path, artifact_bundle_backup) }.not_to raise_error
      expect(File.exist?(@artifact_bundle_file_path)).to eq(true)
    end
  end

  describe '::create_backup_from_file!' do
    it 'should create a backup from local file and extract it' do
      expect { klass.create_backup_from_file!($client_i3s_300, deployment_group, @backup_bundle_file_path, 'BundleBackup') }.not_to raise_error
    end
  end
end
