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
  # Firmware bundle resource implementation
  class FirmwareBundle
    BASE_URI = '/rest/firmware-bundles'.freeze
    BOUNDARY = '----011000010111000001101001'.freeze

    # Uploads a firmware bundle file
    # @param [OneviewSDK::Client] client
    # @param [String] file_path
    # @return [OneviewSDK::FirmwareDriver] if the upload was sucessful, return a FirmwareDriver object
    def self.add(client, file_path)
      fail NotFound, "ERROR: File '#{file_path}' not found!" unless File.file?(file_path)
      options = {}
      options['Content-Type'] = "multipart/form-data; boundary=#{BOUNDARY}"
      options['uploadfilename'] = File.basename(file_path)
      options['body'] = "--#{BOUNDARY}\r\n"
      options['body'] << "Content-Disposition: form-data; name=\"file\"; filename=\"#{File.basename(file_path)}\"\r\n"
      options['body'] << "Content-Type: application/octet-stream; Content-Transfer-Encoding: binary\r\n\r\n"
      options['body'] << "#{IO.binread(file_path)}\r\n--#{BOUNDARY}--"
      response = client.rest_post(BASE_URI, options)
      data = client.response_handler(response)
      OneviewSDK::FirmwareDriver.new(client, data)
    end
  end
end
