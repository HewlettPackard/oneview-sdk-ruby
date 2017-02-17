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

module OneviewSDK
  # Helper for upload of files
  module FileUploadHelper
    READ_TIMEOUT = 300 # in seconds, 5 minutes

    # Uploads a file to a specific uri
    # @param [OneviewSDK::Client] client The client object for the OneView appliance
    # @param [String] file_path
    # @param [String] uri The uri starting with "/"
    # @param [Hash] body_params The params to append to body of http request. Default is {}.
    # @option body_params [String] 'name' The name to show (when resource accepts a name)
    # @param [Integer] timeout The number of seconds to wait for completing the request. Default is 300.
    # @return [OneviewSDK::Resource] if the upload was sucessful, return a Resource object
    def self.upload_file(client, file_path, uri, body_params = {}, timeout = READ_TIMEOUT)
      raise NotFound, "ERROR: File '#{file_path}' not found!" unless File.file?(file_path)
      options = {
        'Content-Type' => 'multipart/form-data',
        'X-Api-Version' => client.api_version.to_s,
        'auth' => client.token
      }
      url = URI.parse(URI.escape("#{client.url}#{uri}"))

      File.open(file_path) do |file|
        name_to_show = body_params.delete('name') || body_params.delete(:name)
        name_to_show = name_to_show ? name_to_show + File.extname('/tmp/artifact_bundle.zip') : File.basename(file_path)
        body_params['file'] = UploadIO.new(file, 'application/octet-stream', name_to_show)
        req = Net::HTTP::Post::Multipart.new(
          url.path,
          body_params,
          options
        )

        http_request = Net::HTTP.new(url.host, url.port)
        http_request.use_ssl = true
        http_request.verify_mode = OpenSSL::SSL::VERIFY_NONE
        http_request.read_timeout = timeout

        http_request.start do |http|
          response = http.request(req)
          return client.response_handler(response)
        end
      end
    end

    # Download a file from a specific uri
    # @param [OneviewSDK::Client] client The client object for the OneView appliance
    # @param [String] uri The uri starting with "/"
    # @param [String] local_drive_path Path to save file downloaded
    # @return [Boolean] if file was downloaded
    def self.download_file(client, uri, local_drive_path)
      options = {
        'Content-Type' => 'application/json',
        'X-Api-Version' => client.api_version.to_s,
        'auth' => client.token
      }

      url = URI.parse(URI.escape("#{client.url}#{uri}"))
      req = Net::HTTP::Get.new(url.request_uri, options)

      http_request = Net::HTTP.new(url.host, url.port)
      http_request.use_ssl = true
      http_request.verify_mode = OpenSSL::SSL::VERIFY_NONE

      http_request.start do |http|
        http.request(req) do |res|
          client.response_handler(res) unless res.code.to_i.between?(200, 204)
          File.open(local_drive_path, 'wb') do |file|
            res.read_body do |segment|
              file.write(segment)
            end
          end
        end
      end
      true
    end
  end
end
