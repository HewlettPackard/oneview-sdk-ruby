# (c) Copyright 2016 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License.

require_relative '../../api200/server_profile'

module OneviewSDK
  module API300
    module Synergy
      # Server profile resource implementation
      class ServerProfile < OneviewSDK::API200::ServerProfile
        LOGICAL_JBOD_URI = '/rest/sas-logical-jbods'.freeze
        ATTACHMENT_URI = '/rest/sas-logical-jbod-attachments'.freeze

        # Create a resource object, associate it with a client, and set its properties.
        # @param [OneviewSDK::Client] client The client object for the OneView appliance
        # @param [Hash] params The options for this resource (key-value pairs)
        # @param [Integer] api_ver The api version to use when interacting with this resource.
        def initialize(client, params = {}, api_ver = nil)
          @data ||= {}
          # Default values
          @data['type'] ||= 'ServerProfileV6'
          super
        end

        # Retrieves all SAS Logical JBOD
        # @param [OneviewSDK::Client] client The client object for the OneView appliance
        def self.get_sas_logical_jbods(client)
          response = client.rest_get(LOGICAL_JBOD_URI)
          response = client.response_handler(response)
          response['members']
        end

        # Retrieves a SAS Logical JBOD by name
        # @param [OneviewSDK::Client] client The client object for the OneView appliance
        # @param [String] name SAS Logical JBOD name
        # @return [Array] SAS Logical JBOD
        def self.get_sas_logical_jbod(client, name)
          results = get_sas_logical_jbods(client)
          results.find { |item| item['name'] == name }
        end

        # Retrieves drives by SAS Logical JBOD name
        # @param [OneviewSDK::Client] client The client object for the OneView appliance
        # @param [String] name SAS Logical JBOD name
        def self.get_sas_logical_jbod_drives(client, name)
          item = get_sas_logical_jbod(client, name)
          response = client.rest_get(item['uri'] + '/drives')
          client.response_handler(response)
        end

        # Retrieves all SAS Logical JBOD Attachments
        # @param [OneviewSDK::Client] client The client object for the OneView appliance
        def self.get_sas_logical_jbod_attachments(client)
          response = client.rest_get(ATTACHMENT_URI)
          response = client.response_handler(response)
          response['members']
        end

        # Retrieves a SAS Logical JBOD Attachment by name
        # @param [OneviewSDK::Client] client The client object for the OneView appliance
        # @param [String] name SAS Logical JBOD Attachment name
        # @return [Array] SAS Logical JBOD Attachment
        def self.get_sas_logical_jbod_attachment(client, name)
          results = get_sas_logical_jbod_attachments(client)
          results.find { |attachment| attachment['name'] == name }
        end

        # Sets the OS deployment settings applicable when deployment is invoked through server profile
        # @param [OneviewSDK::API300::Synergy::OSDeploymentPlan] os_deployment_plan the OSDeploymentPlan resource with valid URI
        # @param [Array(Hash<String, String>)] custom_attributes The custom attributes to be configured on the OS deployment plan.
        #   The internal hashes may contain:
        #   - 'name' [String] name of the attribute
        #   - 'value' [String] value of the attribute
        def set_os_deployment_settings(os_deployment_plan, custom_attributes = [])
          os_deployment_plan.ensure_uri
          @data['osDeploymentSettings'] ||= {}
          @data['osDeploymentSettings']['osDeploymentPlanUri'] = os_deployment_plan['uri']
          @data['osDeploymentSettings']['osCustomAttributes'] = custom_attributes
        end
      end
    end
  end
end
