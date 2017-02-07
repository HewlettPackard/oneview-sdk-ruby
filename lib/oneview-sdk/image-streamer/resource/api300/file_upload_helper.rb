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

    def upload_file(client, file_path, body_params = {}, timeout = READ_TIMEOUT)
      raise NotFound, "ERROR: File '#{file_path}' not found!" unless File.file?(file_path)
      options = {}
      options['Content-Type'] = 'multipart/form-data'
      options['X-Api-Version'] = client.api_version.to_s
      options['auth'] = client.token
      url = URI.parse(URI.escape("#{client.url}#{self::BASE_URI}"))

      File.open(file_path) do |file|
        body_params.merge!({ 'file' => UploadIO.new(file, 'application/octet-stream', File.basename(file_path)) })
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
  end
end