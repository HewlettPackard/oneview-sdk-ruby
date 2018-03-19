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

require_relative '../../api500/c7000/server_profile_template'

module OneviewSDK
  module API600
    module C7000
      # Server Profile Template resource implementation on API600 C7000
      class ServerProfileTemplate < OneviewSDK::API500::C7000::ServerProfileTemplate

        # Create a resource object, associate it with a client, and set its properties.
        # @param [OneviewSDK::Client] client The client object for the OneView appliance
        # @param [Hash] params The options for this resource (key-value pairs)
        # @param [Integer] api_ver The api version to use when interracting with this resource.
        def initialize(client, params = {}, api_ver = nil)
          @data ||= {}
          # Default values
          @data['type'] ||= 'ServerProfileTemplateV4'
          super
        end

        def get_available_networks(client, query = nil)
          query_uri = OneviewSDK::Resource.build_query(query) if query
          puts query_uri
          response = client.rest_get("#{BASE_URI}/available-networks#{query_uri}")
          client.response_handler(response)
        end

     end
    end
  end
end
