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

require_relative '../../api200/volume_template'

module OneviewSDK
  module API300
    module C7000
      # Volume Template resource implementation for API300 Thunderbird
      class VolumeTemplate < OneviewSDK::API200::VolumeTemplate
        # Create the client object, establishes connection, and set up the logging and api version.
        # @param [OneviewSDK::Client] client The client object for the OneView appliance
        # @param [Hash] params The options for this resource (key-value pairs)
        # @param [Integer] api_ver The api version to use when interracting with this resource.
        # Defaults to client.api_version if exists, or OneviewSDK::Client::DEFAULT_API_VERSION.
        # Defaults type to StorageVolumeTemplate when API version is 120
        # Defaults type to StorageVolumeTemplateV3 when API version is 200
        def initialize(client, params = {}, api_ver = nil)
          super
        end
      end
    end
  end
end
