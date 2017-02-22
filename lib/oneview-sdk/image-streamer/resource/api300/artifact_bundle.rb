# (C) Copyright 2017 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License.

require_relative 'resource'

module OneviewSDK
  module ImageStreamer
    module API300
      # Artifacts Bundle resource implementation for Image Streamer
      class ArtifactBundle < Resource
        ACCEPTED_FORMATS = %w(.zip .ZIP).freeze # Supported upload extensions

        BASE_URI = '/rest/artifact-bundles'.freeze
        BACKUPS_URI = "#{BASE_URI}/backups".freeze
        BACKUPS_ARCHIVE_URI = "#{BACKUPS_URI}/archive".freeze

        # Create a resource object, associate it with a client, and set its properties.
        # @param [OneviewSDK::ImageStreamer::Client] client The client object for the Image Streamer appliance
        # @param [Hash] params The options for this resource (key-value pairs)
        # @param [Integer] api_ver The api version to use when interracting with this resource.
        def initialize(client, params = {}, api_ver = nil)
          super
          @data['buildPlans']      ||= []
          @data['planScripts']     ||= []
          @data['deploymentPlans'] ||= []
          @data['goldenImages']    ||= []
        end

        # Creates an artifact bundle resource from the file that is uploaded from admin's local drive
        # @param [OneviewSDK::ImageStreamer::Client] client The client object for the Image Streamer appliance
        # @param [String] file_path The file path with file extension
        # @param [String] artifact_name The name for the artifact that will be created
        # @param [Integer] timeout The number of seconds to wait for completing the request. Default is 300.
        # @return [OneviewSDK::ImageStreamer::API300::ArtifactBundle] if the upload was successful, return a ArtifactBundle object
        def self.create_from_file(client, file_path, artifact_name, timeout = OneviewSDK::Rest::READ_TIMEOUT)
          ensure_file_path_extension!(file_path)

          file_name = artifact_name.dup
          if file_name && !file_name.empty?
            file_name += File.extname(file_path)
          else
            file_name = File.basename(file_path)
          end

          params = { 'name' => file_name }
          body = client.upload_file(file_path, BASE_URI, params, timeout)
          ArtifactBundle.new(client, body)
        end

        # Gets the backup bundles created
        # @param [OneviewSDK::ImageStreamer::Client] client The client object for the Image Streamer appliance
        # @return [Array<ArtifactBundle>] Array of ArtifactBundle
        def self.get_backups(client)
          find_by(client, {}, BACKUPS_URI)
        end

        # Creates a backup bundle with all the artifacts present on the appliance.
        # @param [OneviewSDK::ImageStreamer::Client] client The client object for the Image Streamer appliance
        # @param [DeploymentGroup] deployment_group The DeploymentGroup with name or uri
        # @return [Hash] The result hash with DeploymentGroup data
        def self.create_backup(client, deployment_group)
          ensure_resource!(deployment_group)
          response = client.rest_post(BACKUPS_URI, 'body' => { 'deploymentGroupURI' => deployment_group['uri'] })
          client.response_handler(response)
        end

        # Creates a backup bundle from the zip file
        #   If there are any artifacts existing, they will be removed before the extract operation.
        # @param [OneviewSDK::ImageStreamer::Client] client The client object for the Image Streamer appliance
        # @param [String] file_path The file path with file extension
        # @param [String] artifact_name The name for the artifact that will be created
        # @param [Integer] timeout The number of seconds to wait for completing the request. Default is 300.
        # @return [Hash] The result hash with DeploymentGroup data
        def self.create_backup_from_file!(client, deployment_group, file_path, artifact_name, timeout = OneviewSDK::Rest::READ_TIMEOUT)
          ensure_resource!(deployment_group)
          ensure_file_path_extension!(file_path)

          file_name = artifact_name.dup
          if file_name && !file_name.empty?
            file_name += File.extname(file_path)
          else
            file_name = File.basename(file_path)
          end

          params = { 'name' => file_name, 'deploymentGrpUri' => deployment_group['uri'] }
          client.upload_file(file_path, BACKUPS_ARCHIVE_URI, params, timeout)
        end

        # Download the backup bundle
        # @param [OneviewSDK::ImageStreamer::Client] client The client object for the Image Streamer appliance
        # @param [String] local_drive_path The path where file will be saved
        # @param [String] artifact_bundle_backup The backup ArtifactBundle with 'downloadURI'
        # @return [Boolean] true if backup was downloaded
        def self.download_backup(client, local_drive_path, artifact_bundle_backup)
          raise IncompleteResource, "Missing required attribute 'downloadURI'" unless artifact_bundle_backup['downloadURI']
          client.download_file(artifact_bundle_backup['downloadURI'], local_drive_path)
        end

        # Method is not available
        # @raise [OneviewSDK::MethodUnavailable] method is not available
        def update(*)
          unavailable_method
        end

        # Update the name of Artifact Bundle
        # @param [String] new_name Name to update the Artifact Bundle
        # @return [Boolean] true if name was updated
        # @raise [OneviewSDK::IncompleteResource] if the client or uri is not set
        def update_name(new_name)
          ensure_uri
          response = @client.rest_put(@data['uri'], 'body' => { 'name' => new_name, 'type' => 'ArtifactsBundle' })
          @client.response_handler(response)
          @data['name'] = new_name
          true
        end

        # Extracts the existing backup bundle on the appliance and creates all the artifacts.
        #   If there are any artifacts existing, they will be removed before the extract operation.
        # @param [Boolean] force Forces the extract operation even when there are any conflicts
        # @return [Boolean] true if backup bundle was extracted
        # @raise [OneviewSDK::IncompleteResource] if the client or uri is not set
        def extract(force = true)
          ensure_uri
          options = { 'Content-Type' => 'text/plain' }
          response = @client.rest_put(@data['uri'] + "?extract=true&forceImport=#{force}", options)
          @client.response_handler(response)
          true
        end

        # Downloads the content of the selected artifact bundle to the admin's local drive.
        # @param [String] local_drive_path Path to save file downloaded
        # @return [Boolean] true if the file was downloaded
        def download(local_drive_path)
          raise IncompleteResource, "Missing required attribute 'downloadURI'" unless @data['downloadURI']
          client.download_file(@data['downloadURI'], local_drive_path)
        end

        # Add a Build Plan to this ArtifactBundle
        # @param [OneviewSDK::ImageStreamer::API300::BuildPlan] resource The BuildPlan resource with uri
        # @param [TrueClass, FalseClass] read_only Indicates whether the BuildPlan will be readonly in artifact bundle package
        # @raise [RuntimeError] if the BuildPlan uri is not set or it is not valid
        def add_build_plan(resource, read_only = true)
          add_resource(resource, 'buildPlans', read_only)
        end

        # Add a Plan Script to this ArtifactBundle
        # @param [OneviewSDK::ImageStreamer::API300::PlanScript] resource The PlanScripts resource with uri
        # @param [TrueClass, FalseClass] read_only Indicates whether the PlanScripts will be readonly in artifact bundle package
        # @raise [RuntimeError] if the PlanScripts uri is not set or it is not valid
        def add_plan_script(resource, read_only = true)
          add_resource(resource, 'planScripts', read_only)
        end

        # Add a Deployment Plan to this ArtifactBundle
        # @param [OneviewSDK::ImageStreamer::API300::DeploymentPlans] resource The DeploymentPlans resource with uri
        # @param [TrueClass, FalseClass] read_only Indicates whether the DeploymentPlans will be readonly in artifact bundle package
        # @raise [RuntimeError] if the DeploymentPlans uri is not set or it is not valid
        def add_deployment_plan(resource, read_only = true)
          add_resource(resource, 'deploymentPlans', read_only)
        end

        # Add a Golden Image to this ArtifactBundle
        # @param [OneviewSDK::ImageStreamer::API300::GoldenImage] resource The GoldenImage resource with uri
        # @param [TrueClass, FalseClass] read_only Indicates whether the GoldenImage will be readonly in artifact bundle package
        # @raise [RuntimeError] if the GoldenImage uri is not set or it is not valid
        def add_golden_image(resource, read_only = true)
          add_resource(resource, 'goldenImages', read_only)
        end

        # Fail unless resource can be retrieved
        def self.ensure_resource!(resource)
          raise IncompleteResource, "The resource #{resource.class} can not be retrieved. Ensure it can be retrieved." unless resource.retrieve!
        end

        # Fail unless file extension of file_path is in ACCEPTED_FORMATS array
        def self.ensure_file_path_extension!(file_path)
          raise InvalidFormat, "File extension should be #{ACCEPTED_FORMATS}" unless ACCEPTED_FORMATS.include?(File.extname(file_path))
        end

        private

        # Add resource data to data hash
        # @param [OneviewSDK::Resource] resource The resource with uri
        # @param [String] key_name The hash key of data hash
        # @param [TrueClass, FalseClass] read_only The value of readOnly attribute
        def add_resource(resource, key_name, read_only)
          self.class.ensure_resource!(resource)
          @data[key_name] << { 'resourceUri' => resource['uri'], 'readOnly' => read_only }
        end
      end
    end
  end
end
