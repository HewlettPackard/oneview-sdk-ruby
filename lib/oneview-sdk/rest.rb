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

require 'uri'
require 'net/http'
require 'openssl'
require 'json'
require 'net/http/post/multipart'

module OneviewSDK
  # Contains all of the methods for making API REST calls
  module Rest
    READ_TIMEOUT = 300 # in seconds, 5 minutes

    # Makes a restful API request to OneView
    # @param [Symbol] type The rest method/type Options: [:get, :post, :delete, :patch, :put]
    # @param [String] path The path for the request. Usually starts with "/rest/"
    # @param [Hash] options The options for the request
    # @option options [String] :body Hash to be converted into json and set as the request body
    # @option options [String] :Content-Type ('application/json') Set to nil or :none to have this option removed
    # @option options [Integer] :X-API-Version (client.api_version) API version to use for this request
    # @option options [Integer] :auth (client.token) Authentication token to use for this request
    # @param [Integer] api_ver The api version to use when interracting with this resource
    # @param [Integer] redirect_limit Number of redirects it is allowed to follow
    # @raise [OpenSSL::SSL::SSLError] if SSL validation of OneView instance's certificate failed
    # @return [NetHTTPResponse] Response object
    def rest_api(type, path, options = {}, api_ver = @api_version, redirect_limit = 3)
      @logger.debug "Making :#{type} rest call to #{@url}#{path}"
      raise InvalidRequest, 'Must specify path' unless path
      uri = URI.parse(URI.escape(@url + path))
      http = build_http_object(uri)
      request = build_request(type, uri, options.dup, api_ver)
      response = http.request(request)
      @logger.debug "  Response: Code=#{response.code}. Headers=#{response.to_hash}\n  Body=#{response.body}"
      if response.class <= Net::HTTPRedirection && redirect_limit > 0 && response['location']
        @logger.debug "Redirecting to #{response['location']}"
        return rest_api(type, response['location'], options, api_ver, redirect_limit - 1)
      end
      response
    rescue OpenSSL::SSL::SSLError => e
      msg = 'SSL verification failed for request. Please either:'
      msg += "\n  1. Install the certificate into your system's cert store"
      msg += ". Using cert store: #{ENV['SSL_CERT_FILE']}" if ENV['SSL_CERT_FILE']
      msg += "\n  2. Run oneview-sdk-ruby cert import #{@url}"
      msg += "\n  3. Set the :ssl_enabled option to false for your client (NOT RECOMMENDED)"
      @logger.error msg
      raise e
    end

    # Makes a restful GET request to OneView
    # @param [String] path The path for the request. Usually starts with "/rest/"
    # @param [Hash] options The options for the request
    # @option options [String] :Content-Type ('application/json') Set to nil or :none to have this option removed
    # @option options [Integer] :X-API-Version (client.api_version) API version to use for this request
    # @option options [Integer] :auth (client.token) Authentication token to use for this request
    # @param [Integer] api_ver The api version to use when interracting with this resource
    # @return [NetHTTPResponse] Response object
    def rest_get(path, options = {}, api_ver = @api_version)
      rest_api(:get, path, options, api_ver)
    end

    # Makes a restful POST request to OneView
    # @param [String] path The path for the request. Usually starts with "/rest/"
    # @param [Hash] options The options for the request
    # @option options [String] :body Hash to be converted into json and set as the request body
    # @option options [String] :Content-Type ('application/json') Set to nil or :none to have this option removed
    # @option options [Integer] :X-API-Version (client.api_version) API version to use for this request
    # @option options [Integer] :auth (client.token) Authentication token to use for this request
    # @param [Integer] api_ver The api version to use when interracting with this resource
    # @return [NetHTTPResponse] Response object
    def rest_post(path, options = {}, api_ver = @api_version)
      rest_api(:post, path, options, api_ver)
    end

    # Makes a restful PUT request to OneView
    # @param [String] path The path for the request. Usually starts with "/rest/"
    # @param [Hash] options The options for the request
    # @option options [String] :body Hash to be converted into json and set as the request body
    # @option options [String] :Content-Type ('application/json') Set to nil or :none to have this option removed
    # @option options [Integer] :X-API-Version (client.api_version) API version to use for this request
    # @option options [Integer] :auth (client.token) Authentication token to use for this request
    # @param [Integer] api_ver The api version to use when interracting with this resource
    # @return [NetHTTPResponse] Response object
    def rest_put(path, options = {}, api_ver = @api_version)
      rest_api(:put, path, options, api_ver)
    end

    # Makes a restful PATCH request to OneView
    # @param [String] path The path for the request. Usually starts with "/rest/"
    # @param [Hash] options The options for the request
    # @option options [String] :body Hash to be converted into json and set as the request body
    # @option options [String] :Content-Type ('application/json') Set to nil or :none to have this option removed
    # @option options [Integer] :X-API-Version (client.api_version) API version to use for this request
    # @option options [Integer] :auth (client.token) Authentication token to use for this request
    # @param [Integer] api_ver The api version to use when interracting with this resource
    # @return [NetHTTPResponse] Response object
    def rest_patch(path, options = {}, api_ver = @api_version)
      rest_api(:patch, path, options, api_ver)
    end

    # Makes a restful DELETE request to OneView
    # @param [String] path The path for the request. Usually starts with "/rest/"
    # @param [Hash] options The options for the request
    # @option options [String] :body Hash to be converted into json and set as the request body
    # @option options [String] :Content-Type ('application/json') Set to nil or :none to have this option removed
    # @option options [Integer] :X-API-Version (client.api_version) API version to use for this request
    # @option options [Integer] :auth (client.token) Authentication token to use for this request
    # @param [Integer] api_ver The api version to use when interracting with this resource
    # @return [NetHTTPResponse] Response object
    def rest_delete(path, options = {}, api_ver = @api_version)
      rest_api(:delete, path, options, api_ver)
    end

    # Uploads a file to a specific uri
    # @param [String] file_path
    # @param [String] path The url path starting with "/"
    # @param [Hash] options The options for the request. Default is {}.
    # @option options [String] :body Hash to be converted into json and set as the request body
    # @option options [String] :header Hash to be converted into json and set as the request header
    # @option options [String] :file_name String that defines the new file name
    # @param [Integer] timeout The number of seconds to wait for completing the request. Default is 300.
    # @return [Hash] The parsed JSON body of response
    def upload_file(file_path, path, options = {}, timeout = READ_TIMEOUT)
      raise NotFound, "ERROR: File '#{file_path}' not found!" unless File.file?(file_path)
      options = Hash[options.map { |k, v| [k.to_s, v] }]
      body_params = options['body'] || {}
      headers_params = options['header'] || {}
      headers = {
        'Content-Type' => 'multipart/form-data',
        'X-Api-Version' => @api_version.to_s,
        'auth' => @token
      }
      headers.merge!(headers_params)

      File.open(file_path) do |file|
        name_to_show = options['file_name'] || File.basename(file_path)
        body_params['file'] = UploadIO.new(file, 'application/octet-stream', name_to_show)

        uri = URI.parse(URI.escape(@url + path))
        http_request = build_http_object(uri)
        http_request.read_timeout = timeout

        req = Net::HTTP::Post::Multipart.new(
          uri.path,
          body_params,
          headers
        )

        http_request.start do |http|
          begin
            response = http.request(req)
            return response_handler(response)
          rescue Net::ReadTimeout
            raise "The connection was closed because the timeout of #{timeout} seconds has expired."\
              'You can specify the timeout in seconds by passing the timeout on the method call.'\
              'Interrupted file uploads may result in corrupted file remaining in the appliance.'\
              'HPE recommends checking the appliance for corrupted file and removing it.'
          end
        end
      end
    end

    # Download a file from a specific uri
    # @param [String] path The url path starting with "/"
    # @param [String] local_drive_path Path to save file downloaded
    # @return [Boolean] if file was downloaded
    def download_file(path, local_drive_path)
      uri = URI.parse(URI.escape(@url + path))
      http_request = build_http_object(uri)
      req = build_request(:get, uri, {}, @api_version.to_s)

      http_request.start do |http|
        http.request(req) do |res|
          response_handler(res) unless res.code.to_i.between?(200, 204)
          File.open(local_drive_path, 'wb') do |file|
            res.read_body do |segment|
              file.write(segment)
            end
          end
        end
      end
      true
    end

    RESPONSE_CODE_OK           = 200
    RESPONSE_CODE_CREATED      = 201
    RESPONSE_CODE_ACCEPTED     = 202
    RESPONSE_CODE_NO_CONTENT   = 204
    RESPONSE_CODE_BAD_REQUEST  = 400
    RESPONSE_CODE_UNAUTHORIZED = 401
    RESPONSE_CODE_NOT_FOUND    = 404

    # Handles the response from a rest call.
    #   If an asynchronous task was started, this waits for it to complete.
    # @param [HTTPResponse] response HTTP response
    # @param [Boolean] wait_on_task Wait on task (or just return task details)
    # @raise [OneviewSDK::OneViewError] if the request failed or a task did not complete successfully
    # @return [Hash] The parsed JSON body
    def response_handler(response, wait_on_task = true)
      case response.code.to_i
      when RESPONSE_CODE_OK # Synchronous read/query
        begin
          return JSON.parse(response.body)
        rescue JSON::ParserError => e
          @logger.warn "Failed to parse JSON response. #{e}"
          return response.body
        end
      when RESPONSE_CODE_CREATED # Synchronous add
        JSON.parse(response.body)
      when RESPONSE_CODE_ACCEPTED # Asynchronous add, update or delete
        return JSON.parse(response.body) unless wait_on_task
        @logger.debug "Waiting for task: response.header['location']"
        uri = response.header['location'] || JSON.parse(response.body)['uri'] # If task uri is not returned in header
        task = wait_for(uri)
        return true unless task['associatedResource'] && task['associatedResource']['resourceUri']
        resource_data = rest_get(task['associatedResource']['resourceUri'])
        JSON.parse(resource_data.body)
      when RESPONSE_CODE_NO_CONTENT # Synchronous delete
        {}
      when RESPONSE_CODE_BAD_REQUEST
        BadRequest.raise! "400 BAD REQUEST #{response.body}", response
      when RESPONSE_CODE_UNAUTHORIZED
        Unauthorized.raise! "401 UNAUTHORIZED #{response.body}", response
      when RESPONSE_CODE_NOT_FOUND
        NotFound.raise! "404 NOT FOUND #{response.body}", response
      else
        RequestError.raise! "#{response.code} #{response.body}", response
      end
    end


    private

    # Builds a http object using the data given
    def build_http_object(uri)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true if uri.scheme == 'https'
      if @ssl_enabled
        http.cert_store = @cert_store if @cert_store
      else http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
      http.read_timeout = @timeout if @timeout # Timeout for a request
      http.open_timeout = @timeout if @timeout # Timeout for a connection
      http
    end

    # Builds a request object using the data given
    def build_request(type, uri, options, api_ver)
      case type.downcase.to_sym
      when :get
        request = Net::HTTP::Get.new(uri.request_uri)
      when :post
        request = Net::HTTP::Post.new(uri.request_uri)
      when :put
        request = Net::HTTP::Put.new(uri.request_uri)
      when :patch
        request = Net::HTTP::Patch.new(uri.request_uri)
      when :delete
        request = Net::HTTP::Delete.new(uri.request_uri)
      else
        raise InvalidRequest, "Invalid rest method: #{type}. Valid methods are: get, post, put, patch, delete"
      end

      options['X-API-Version'] ||= api_ver
      options['auth'] ||= @token
      options['Content-Type'] ||= 'application/json'
      options.delete('Content-Type')  if [:none, 'none', nil].include?(options['Content-Type'])
      options.delete('X-API-Version') if [:none, 'none', nil].include?(options['X-API-Version'])
      options.delete('auth')          if [:none, 'none', nil].include?(options['auth'])
      options.each do |key, val|
        if key.to_s.downcase == 'body'
          request.body = val.to_json rescue val
        else
          request[key] = val
        end
      end

      @logger.debug "  Options: #{options}" # Warning: This may include passwords and tokens

      request
    end
  end
end
