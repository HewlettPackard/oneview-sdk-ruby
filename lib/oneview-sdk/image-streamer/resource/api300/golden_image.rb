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
require 'net/http/post/multipart'

module OneviewSDK
  module ImageStreamer
    module API300
      # Golden Image resource implementation for Image Streamer
      class GoldenImage < Resource
        BASE_URI = '/rest/golden-images'.freeze
        READ_TIMEOUT = 300 # in seconds, 5 minutes
        ACCEPTED_FORMATS = %w(.zip .ZIP).freeze # Supported upload extensions

        # Create a resource object, associate it with a client, and set its properties.
        # @param [OneviewSDK::ImageStreamer::Client] client The client object for the Image Streamer appliance
        # @param [Hash] params The options for this resource (key-value pairs)
        # @param [Integer] api_ver The api version to use when interracting with this resource.
        def initialize(client, params = {}, api_ver = nil)
          super
          # Default values:
          @data['type'] ||= 'GoldenImage'
        end

        # Download the details of the golden image capture logs which has been archived based on the specific attribute ID.
        # @param [String] file_path
        # @return [True] When was saved successfully
        def get_details_archive(file_path)
          ensure_client && ensure_uri
          url = URI.parse(URI.escape("#{@client.url}#{BASE_URI}"))
          options = { use_ssl: true, verify_mode: OpenSSL::SSL::VERIFY_NONE }
          Net::HTTP.start(url.host, url.port, options) do |http|
            resp = http.get("/archive/#{@data['uri'].split('/').last}")
            File.open(file_path, 'wb') { |file| file.write(resp.body) }
          end
          true
        end

        # Downloads the content of the selected golden image as per the specified attributes.
        # @param [String] file_path
        # @return [True] When was saved successfully
        def download(file_path)
          ensure_client && ensure_uri
          url = URI.parse(URI.escape("#{@client.url}#{BASE_URI}"))
          options = { use_ssl: true, verify_mode: OpenSSL::SSL::VERIFY_NONE }
          Net::HTTP.start(url.host, url.port, options) do |http|
            resp = http.get("/download/#{@data['uri'].split('/').last}")
            File.open(file_path, 'wb') { |file| file.write(resp.body) }
          end
          true
        end

        # Adds an golden image resource from the file that is uploaded from a local drive.
        # Only the .zip format file can be used for upload.
        # @param [OneviewSDK::ImageStreamer::Client] client The client object for the Image Streamer appliance
        # @param [String] file_path
        # @param [Hash] options The
        # @option options [String] :name The name of the Golden Image
        # @option options [String] :description The description of the Golden Image
        # @param [Integer] timeout The number of seconds to wait for completing the request
        def self.add(client, file_path, options = {}, timeout = READ_TIMEOUT)
          options = Hash[options.map { |k, v| [k.to_s, v] }] # Convert symbols hash keys to string
          raise NotFound, "ERROR: File '#{file_path}' not found!" unless File.file?(file_path)
          raise InvalidFormat, 'ERROR: File with extension not supported!' unless ACCEPTED_FORMATS.include? File.extname(file_path)
          raise IncompleteResource, 'Please set the name of the golden image!' unless options['name']
          raise IncompleteResource, 'Please set the description of the golden image!' unless options['description']
          options['Content-Type'] = 'multipart/form-data'
          options['X-Api-Version'] = client.api_version.to_s
          options['auth'] = client.token
          options['file'] = File.basename(file_path)
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
            http_request.read_timeout = timeout

            response = http_request.start do |http|
              response = http.request(req)
              return client.response_handler(response)
            end
          end
        end

        # Sets the os volume
        # @param [OneviewSDK::ImageStreamer::API300::OsVolumes] os_volume
        def set_os_volume(os_volume)
          raise IncompleteResource, 'Please set the OS Volume\'s uri attribute!' unless os_volume['uri']
          set('osVolumeURI', os_volume['uri'])
        end

        # Sets the build plan
        # @param [OneviewSDK::ImageStreamer::API300::BuildPlan] build_plan
        def set_build_plan(build_plan)
          raise IncompleteResource, 'Please set the Build Plan\'s uri attribute!' unless build_plan['uri']
          set('buildPlanUri', build_plan['uri'])
        end
      end
    end
  end
end
