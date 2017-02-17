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

require_relative '../../_client_i3s' # Gives access to @client

# Example:
# - Create, update, download, upload, extract and delete an artifact bundle for an API300 Image Streamer
# - Create, download, upload an backup bundle for an API300 Image Streamer
# NOTE: It is needed a DeploymentGroup and a PlanScript previously created

deployment_group = OneviewSDK::ImageStreamer::API300::DeploymentGroup.get_all(@client).first
plan_script = OneviewSDK::ImageStreamer::API300::PlanScript.get_all(@client).first

options = {
  name: 'ArtifactBundle Name',
  description: 'Description of ArtifactBundle'
}

puts "\nCreating an artifact bundle with plan script"
item = OneviewSDK::ImageStreamer::API300::ArtifactBundle.new(@client, options)
item.add_plan_script(plan_script, false)
item.create
puts "Artifact Bundle with name #{item['name']} and uri #{item['uri']} created successfully."
puts 'Data:', item.data

puts "\nUpdating the name of the artifact bundle"
item.update_name("#{item['name']}_Updated")
puts "Artifact Bundle with name #{item['name']} and uri #{item['uri']} updated successfully."

puts "\nListing all artifact bundles"
all_items = OneviewSDK::ImageStreamer::API300::ArtifactBundle.get_all(@client)
all_items.each { |each_item| puts each_item['name'] }

download_path = '/tmp/artifact-bundle.zip'
puts "\nDownloading artifact bundle file and saving at #{download_path}"
item.download(download_path)
puts 'Downloaded successfully.' if File.exist?(download_path)

puts "\nCreating artifact bundle from zip file"
item_uploaded = OneviewSDK::ImageStreamer::API300::ArtifactBundle.create_from_file(@client, download_path, 'ArtifactBundle Uploaded')
puts "Artifact Bundle with name #{item_uploaded['name']} and uri #{item_uploaded['uri']} created successfully."

puts "\nExtracting artifact bundle uploaded"
puts 'Artifact Bundle extracted successfully.' if item_uploaded.extract

puts "\nCreating a backup associated to deployment group with name='#{deployment_group['name']}' and uri='#{deployment_group['uri']}'"
puts OneviewSDK::ImageStreamer::API300::ArtifactBundle.create_backup(@client, deployment_group)

puts "\nListing backups"
backups = OneviewSDK::ImageStreamer::API300::ArtifactBundle.get_backups(@client)
backups.each { |bkp| puts bkp['name'] }

backup_download_path = '/tmp/backup-bundle.zip'
puts "\nDownloading backup bundle file and saving at #{backup_download_path}"
OneviewSDK::ImageStreamer::API300::ArtifactBundle.download_backup(@client, backup_download_path, item)
puts 'Downloaded successfully.' if File.exist?(backup_download_path)

puts "\nUploading backup bundle"
puts OneviewSDK::ImageStreamer::API300::ArtifactBundle.create_backup_from_file(@client, backup_download_path, 'Backup Bundle Uploaded')

puts "\nDeleting the artifact bundles"
item.delete
item_uploaded.delete
puts "#{item['name']} deleted successfully" unless item.retrieve!
puts "#{item_uploaded['name']} deleted successfully" unless item_uploaded.retrieve!
