# (C) Copyright 2021 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.

require 'tempfile'
require_relative '../_client_i3s' # Gives access to @client

# Supported APIs:
# - 1000, 1020, 1600, 2000, 2010, 2020

# Resources that can be created according to parameters:
# api_version = 1000 & variant = Synergy to OneviewSDK::ImageStreamer::API1000::ArtifactBundle
# api_version = 1020 & variant = Synergy to OneviewSDK::ImageStreamer::API1020::ArtifactBundle
# api_version = 1600 & variant = Synergy to OneviewSDK::ImageStreamer::API1600::ArtifactBundle
# api_version = 2000 & variant = Synergy to OneviewSDK::ImageStreamer::API2000::ArtifactBundle
# api_version = 2010 & variant = Synergy to OneviewSDK::ImageStreamer::API2010::ArtifactBundle
# api_version = 2020 & variant = Synergy to OneviewSDK::ImageStreamer::API2020::ArtifactBundle

# Example:
# - Create, update, download, upload, extract and delete an artifact bundle for an Image Streamer
# - Create, download, upload an backup bundle for an Image Streamer
# NOTE: It needs a DeploymentGroup and a PlanScript created already

deployment_group_class = OneviewSDK::ImageStreamer.resource_named('DeploymentGroup', @client.api_version)
deployment_group = deployment_group_class.get_all(@client).first
plan_script_class = OneviewSDK::ImageStreamer.resource_named('PlanScript', @client.api_version)
plan_script = plan_script_class.get_all(@client).first
artifact_bundle_class = OneviewSDK::ImageStreamer.resource_named('ArtifactBundle', @client.api_version)

options = {
  name: 'ArtifactBundle Name',
  description: 'Description of ArtifactBundle'
}

puts "\nCreating an artifact bundle with plan script"
item = artifact_bundle_class.new(@client, options)
item.add_plan_script(plan_script, false)
item.create
puts "Artifact Bundle with name #{item['name']} and uri #{item['uri']} created successfully."
puts 'Data:', item.data

puts "\nUpdating the name of the artifact bundle"
item.update_name("#{item['name']}_Updated")
puts "Artifact Bundle with name #{item['name']} and uri #{item['uri']} updated successfully."

puts "\nListing all artifact bundles"
all_items = artifact_bundle_class.get_all(@client)
all_items.each { |each_item| puts each_item['name'] }

download_file = Tempfile.new(['artifact-bundle', '.zip'])
download_path = download_file.path
puts "\nDownloading artifact bundle file and saving at #{download_path}"
item.download(download_path)
puts 'Downloaded successfully.' if File.exist?(download_path)

puts "\nCreating artifact bundle from zip file"
item_uploaded = artifact_bundle_class.create_from_file(@client, download_path, 'ArtifactBundle Uploaded')
puts "Artifact Bundle with name #{item_uploaded['name']} and uri #{item_uploaded['uri']} created successfully."

puts "\nExtracting artifact bundle uploaded"
puts 'Artifact Bundle extracted successfully.' if item_uploaded.extract

puts "\nCreating a backup associated to deployment group with name='#{deployment_group['name']}' and uri='#{deployment_group['uri']}'"
puts artifact_bundle_class.create_backup(@client, deployment_group)

puts "\nListing backups"
backups = artifact_bundle_class.get_backups(@client)
backups.each { |bkp| puts bkp['name'] }

backup_download_file = Tempfile.new(['backup-bundle', '.zip'])
backup_download_path = backup_download_file.path
puts "\nDownloading backup bundle file and saving at #{backup_download_path}"
artifact_bundle_class.download_backup(@client, backup_download_path, backups.first)
puts 'Downloaded successfully.' if File.exist?(backup_download_path)

puts "\nUploading backup bundle"
puts artifact_bundle_class.create_backup_from_file!(@client, deployment_group, backup_download_path, 'Backup Bundle')

puts "\nExtracting backup bundle uploaded"
backup = artifact_bundle_class.get_backups(@client).first
puts artifact_bundle_class.extract_backup(@client, deployment_group, backup)
puts 'Backup extracted successfully'

puts "\nDeleting the artifact bundles"
item.delete
item_uploaded.delete
puts "#{item['name']} deleted successfully" unless item.retrieve!
puts "#{item_uploaded['name']} deleted successfully" unless item_uploaded.retrieve!
