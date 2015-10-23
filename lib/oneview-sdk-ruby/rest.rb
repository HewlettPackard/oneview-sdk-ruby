require 'uri'
require 'net/http'
require 'openssl'

module OneviewSDK
  # Contains all the methods for making API REST calls
  module Rest
    # Make a restful API request to OneView
    # @param [Symbol] type the rest method/type Options are :get, :post, :delete, and :put
    # @param [String] path the path for the request. Usually starts with "/rest/"
    # @param [Hash] options the options for the request
    # @option options [String] :body Hash to be converted into json and set as the request body
    # @option options [String] :Content-Type ('application/json') Set to nil or :none to have this option removed
    # @option options [Integer] :X-API-Version (200) API version to use for this request.
    # @option options [Integer] :auth Authentication token to use for this request. Defaults to client.token
    # @return [Hash] if request is successful. Hash is of response body
    # @return [NetHTTPResponse] if request is unsuccessful
    def rest_api(type, path, options = {}, api_ver = @api_version)
      @logger.debug "Making :#{type} rest call to #{@url}#{path}"

      uri = URI.parse(URI.escape(@url + path))
      options['X-API-Version'] ||= api_ver || @api_version
      options['auth'] ||= @token

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true if uri.scheme == 'https'
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE unless @ssl_enabled

      case type.downcase
      when 'get', :get
        request = Net::HTTP::Get.new(uri.request_uri)
      when 'post', :post
        request = Net::HTTP::Post.new(uri.request_uri)
      when 'put', :put
        request = Net::HTTP::Put.new(uri.request_uri)
      when 'delete', :delete
        request = Net::HTTP::Delete.new(uri.request_uri)
      else
        fail "Invalid rest call: #{type}"
      end
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
      filtered_options = options.to_s
      filtered_options.gsub!(@password, 'filtered') if @password
      filtered_options.gsub!(@token, 'filtered') if @token
      @logger.debug "  Options: #{filtered_options}"

      response = http.request(request)
      @logger.debug "  Response: #{response.code}: #{response.body}"
      JSON.parse(response.body) rescue response
    rescue OpenSSL::SSL::SSLError => e
      msg = 'SSL verification failed for request. Please either:'
      msg += "\n  1. Install the certificate into your cert store"
      msg += ". Using cert store: #{ENV['SSL_CERT_FILE']}" if ENV['SSL_CERT_FILE']
      msg += "\n  2. Set the :ssl_enabled option to false for your client"
      raise "#{e.message}\n\n#{msg}\n\n"
    end

    # Make a restful GET request to OneView
    # Parameters & return value align with those of the {OneviewSDK::Rest::rest_api} method above
    def rest_get(path, api_ver = @api_version)
      rest_api(:get, path, {}, api_ver)
    end

    # Make a restful GET request to OneView
    # Parameters & return value align with those of the {OneviewSDK::Rest::rest_api} method above
    def rest_post(path, options = {}, api_ver = @api_version)
      rest_api(:post, path, options, api_ver)
    end

    # Make a restful GET request to OneView
    # Parameters & return value align with those of the {OneviewSDK::Rest::rest_api} method above
    def rest_put(path, options = {}, api_ver = @api_version)
      rest_api(:put, path, options, api_ver)
    end

    # Make a restful GET request to OneView
    # Parameters & return value align with those of the {OneviewSDK::Rest::rest_api} method above
    def rest_delete(path, api_ver = @api_version)
      rest_api(:delete, path, {}, api_ver)
    end
  end
end
