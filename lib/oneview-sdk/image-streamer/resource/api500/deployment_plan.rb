# (C) Copyright 2018 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License.

require_relative '../api300/deployment_plan'

module OneviewSDK
  module ImageStreamer
    module API500
      # Deployment Plan resource implementation for Image Streamer
      class DeploymentPlan < OneviewSDK::ImageStreamer::API300::DeploymentPlan

        # Create a resource object, associate it with a client, and set its properties.
        # @param [OneviewSDK::ImageStreamer::Client] client The client object for the OneView appliance
        # @param [Hash] params The options for this resource (key-value pairs)
        # @param [Integer] api_ver The api version to use when interracting with this resource.
        def initialize(client, params = {}, api_ver = nil)
          @data ||= {}
          # Default values:
          @data['type'] ||= 'OEDeploymentPlanV5'
          super
        end

        # Retrieves the Deployment Plan details as per the selected attributes.
        # @return [Hash] The OS Deployment Plan.
        def get_used_by
          ensure_client && ensure_uri
          path = "#{BASE_URI}/#{@data['uri'].split('/').last}/usedby/"
          response = @client.rest_get(path, { 'Content-Type' => 'none' }, @api_version)
          @client.response_handler(response)
        end
      end
    end
  end
end
