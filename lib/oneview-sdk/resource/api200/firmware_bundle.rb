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
      # @return [OneviewSDK::FirmwareDriver] if the upload was sucessful, return a FirmwareDriver object
      def self.add(client, file_path)
        raise NotFound, "ERROR: File '#{file_path}' not found!" unless File.file?(file_path)
        options = {}
        options['Content-Type'] = 'multipart/form-data'
        options['X-Api-Version'] = client.api_version.to_s
        options['auth'] = client.token
        options['uploadfilename'] = File.basename(file_path)
        url = URI.parse(URI.escape("#{client.url}#{BASE_URI}"))

        File.open(file_path) do |file|
          req = Net::HTTP::Post::Multipart.new(
            url.path,
            { 'file' => UploadIO.new(file, 'application/octet-stream', File.basename(file_path)) },
            options
          )

          http_request = Net::HTTP.new(url.host, url.port)
          http_request.use_ssl = true
          http_request.verify_mode = OpenSSL::SSL::VERIFY_NONE
          http_request.start do |http|
            response = http.request(req)
            data = client.response_handler(response)
            return OneviewSDK::FirmwareDriver.new(client, data)
          end
        end
      end
    end
  end
end
