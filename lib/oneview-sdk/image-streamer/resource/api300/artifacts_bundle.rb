# (C) Copyright 2016 Hewlett Packard Enterprise Development LP
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
require_relative 'file_upload_helper'

module OneviewSDK
  module ImageStreamer
    module API300
      # Artifacts Bundle resource implementation for Image Streamer
      class ArtifactsBundle < Resource
        extend OneviewSDK::FileUploadHelper

        BASE_URI = '/rest/artifact-bundles'.freeze
        BACKUPS_URI = "#{BASE_URI}/backups".freeze
        BACKUPS_ARCHIVE_URI = "#{BACKUPS_URI}/archive".freeze

        # Creates an artifacts bundle resource from the file that is uploaded from admin's local drive
        # @param [OneviewSDK::ImageStreamer::Client] client The client object for the Image Streamer appliance
        # @param [String] file_path
        # @param [String] artifact_name
        # @param [Integer] timeout The number of seconds to wait for completing the request
        # @return [OneviewSDK::ImageStreamer::API300::ArtifactsBundle] if the upload was sucessful, return a ArtifactsBundle object
        def self.create_from_file(client, file_path, artifact_name, timeout = OneviewSDK::FileUploadHelper::READ_TIMEOUT)
          params = { 'name' => artifact_name }
          body = upload_file(client, file_path, params, timeout)
          ArtifactsBundle.new(client, body['members']) if body['members']
        end

        # Gets the backup bundle created with all the artifacts present on the appliance.
        # @param [OneviewSDK::ImageStreamer::Client] client The client object for the Image Streamer appliance
        # @return [Array[Hash]] Array of ArtifactsBundle
        def self.backup(client)
          response = client.rest_get(BACKUPS_URI)
          body = client.response_handler(response)
          ArtifactsBundle.new(client, body['members']) if body['members']
        end

        # Creates a backup bundle with all the artifacts present on the appliance.
        # @param [OneviewSDK::ImageStreamer::Client] client The client object for the Image Streamer appliance
        # @param [DeploymentGroup] deployment_group The DeploymentGroup with name or uri
        # @return [Hash] Hash of backup result
        def self.create_backup(client, deployment_group)
          deployment_group.retrieve!
          response = client.rest_post(BACKUPS_URI, { 'deploymentGroupURI' => deployment_group['uri'] })
          client.response_handler(response)
        end

        def self.create_backup_from_file(client, file_path, artifact_name, timeout = READ_TIMEOUT)
          deployment_group.retrieve!
          params = { 'name' => artifact_name, 'deploymentGrpUri' => deployment_group['uri'] }
          upload_file(client, file_path, params, timeout)
        end

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

        # Add a Build Plan to this ArtifactsBundle
        # @param [OneviewSDK::ImageStreamer::API300::BuildPlan] resource The BuildPlan resource with uri
        # @param [TrueClass, FalseClass] read_only Indicates whether the BuildPlan will be readonly in artifact bundle package
        # @raise [RuntimeError] if the BuildPlan uri is not set or it is not valid
        def add_build_plan(resource, read_only = true)
          add_resource(resource, 'buildPlans', read_only)
        end

        # Add a Build Plan to this ArtifactsBundle
        # @param [OneviewSDK::ImageStreamer::API300::PlanScripts] resource The PlanScripts resource with uri
        # @param [TrueClass, FalseClass] read_only Indicates whether the PlanScripts will be readonly in artifact bundle package
        # @raise [RuntimeError] if the PlanScripts uri is not set or it is not valid
        def add_plan_script(resource, read_only = true)
          add_resource(resource, 'planScripts', read_only)
        end

        # Add a Build Plan to this ArtifactsBundle
        # @param [OneviewSDK::ImageStreamer::API300::DeploymentPlans] resource The DeploymentPlans resource with uri
        # @param [TrueClass, FalseClass] read_only Indicates whether the DeploymentPlans will be readonly in artifact bundle package
        # @raise [RuntimeError] if the DeploymentPlans uri is not set or it is not valid
        def add_deployment_plan(resource, read_only = true)
          add_resource(resource, 'deploymentPlans', read_only)
        end

        # Add a Build Plan to this ArtifactsBundle
        # @param [OneviewSDK::ImageStreamer::API300::GoldenImage] resource The GoldenImage resource with uri
        # @param [TrueClass, FalseClass] read_only Indicates whether the GoldenImage will be readonly in artifact bundle package
        # @raise [RuntimeError] if the GoldenImage uri is not set or it is not valid
        def add_golden_image(resource, read_only = true)
          add_resource(resource, 'goldenImages', read_only)
        end

        private

        def add_resource(resource, key_name, read_only)
          if resource.retrieve!
            @data[key_name] << { 'resourceUri' => resource['uri'], 'readOnly' => read_only }
          else
            raise 'The resource can not be retrieved. Ensure it have a valid URI.'
          end
        end

      end
    end
  end
end
