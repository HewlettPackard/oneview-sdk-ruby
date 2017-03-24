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

module OneviewSDK
  module API200
    # Firmware bundle resource implementation
    class FirmwareBundle
      BASE_URI = '/rest/firmware-bundles'.freeze

      # Uploads a firmware bundle file
      # @param [OneviewSDK::Client] client The client object for the OneView appliance
      # @param [String] file_path
      # @param [Integer] timeout The number of seconds to wait for completing the request
      # @return [OneviewSDK::FirmwareDriver] if the upload was successful, return a FirmwareDriver object
      def self.add(client, file_path, timeout = OneviewSDK::Rest::READ_TIMEOUT)
        options = { 'header' => { 'uploadfilename' => File.basename(file_path) } }
        result = client.upload_file(file_path, BASE_URI, options, timeout)
        OneviewSDK::FirmwareDriver.new(client, result)
      end
    end
  end
end
