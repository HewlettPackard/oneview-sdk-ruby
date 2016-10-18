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

require_relative '../../api200/server_profile_template'

module OneviewSDK
  module API300
    module C7000
      # Server Profile Template resource implementation on API300 C7000
      class ServerProfileTemplate < OneviewSDK::API200::ServerProfileTemplate

        def initialize(client, params = {}, api_ver = nil)
          @data ||= {}
          # Default values
          @data['type'] ||= 'ServerProfileTemplateV2'
          super
        end

        # Transforms an existing profile template by supplying a new server hardware type and/or enclosure group.
        # A profile template will be returned with a new configuration based on the capabilities of the supplied
        # server hardware type and/or enclosure group. All configured connections will have their port assignment set to 'Auto'.
        # The new profile template can subsequently be used for the PUT https://{appl}/rest/server-profile-templates/{id}
        # API but is not guaranteed to pass validation. Any incompatibilities will be flagged
        # when the transformed server profile template is submitted.
        # @param [OneviewSDK::Client] client The client object for the OneView appliance
        # @param [Hash<String,Object>] query Query parameters
        # @option query [OneviewSDK::EnclosureGroup] 'enclosure_group' Enclosure Group associated with the resource
        # @option query [OneviewSDK::ServerHardwareType] 'server_hardware_type' The server hardware type associated with the resource
        # @return [Hash] Hash containing the required information
        def get_transformation(client, query = nil)
          query_uri = OneviewSDK::Resource.build_query(query) if query
          puts query_uri
          response = client.rest_get("#{@data['uri']}/transformation#{query_uri}")
          client.response_handler(response)
        end
      end
    end
  end
end
