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

require 'time'
require 'date'

module OneviewSDK
  module API200
  # Enclosure resource implementation
  class Enclosure < BaseResource
    BASE_URI = '/rest/enclosures'.freeze

    # Remove resource from OneView
    # @return [true] if resource was removed successfully
    alias remove delete

    # Create a resource object, associate it with a client, and set its properties.
    # @param [OneviewSDK::Client] client The client object for the OneView appliance
    # @param [Hash] params The options for this resource (key-value pairs)
    # @param [Integer] api_ver The api version to use when interracting with this resource.
    def initialize(client, params = {}, api_ver = nil)
      super
      # Default values:
      @data['type'] ||= 'EnclosureV200'
    end


    # Method is not available
    # @raise [OneviewSDK::MethodUnavailable] method is not available
    def create
      unavailable_method
    end

    # Method is not available
    # @raise [OneviewSDK::MethodUnavailable] method is not available
    def delete
      unavailable_method
    end

    # Claim/configure the enclosure and its components to the appliance
    # @note Calls the refresh method to set additional data
    # @return [OneviewSDK::Enclosure] self
    def add
      ensure_client
      required_attributes = %w(enclosureGroupUri hostname username password licensingIntent)
      required_attributes.each { |k| fail IncompleteResource, "Missing required attribute: '#{k}'" unless @data.key?(k) }

      optional_attrs = %w(enclosureUri firmwareBaselineUri force forceInstallFirmware state unmanagedEnclosure updateFirmwareOn)
      temp_data = @data.select { |k, _v| required_attributes.include?(k) || optional_attrs.include?(k) }
      response = @client.rest_post(self.class::BASE_URI, { 'body' => temp_data }, @api_version)
      new_data = @client.response_handler(response)
      old_name = @data.select { |k, _v| %w(name rackName).include?(k) } # Save name (if given)
      %w(username password hostname).each { |k| @data.delete(k) } # These are no longer needed
      set_all(new_data)
      set_all(old_name)
      update
      self
    end

    # Overrides the update operation because only the name and rackName can be updated (and it uses PATCH).
    # @param [Hash] attributes attributes to be updated
    # @return [OneviewSDK::Enclosure] self
    def update(attributes = {})
      set_all(attributes)
      ensure_client && ensure_uri
      cur_state = self.class.find_by(@client, uri: @data['uri']).first
      unless cur_state[:name] == @data['name']
        temp_data = [{ op: 'replace', path: '/name', value: @data['name'] }]
        response = @client.rest_patch(@data['uri'], { 'body' => temp_data }, @api_version)
        @client.response_handler(response)
      end
      unless cur_state[:rackName] == @data['rackName']
        temp_data = [{ op: 'replace', path: '/rackName', value: @data['rackName'] }]
        response = @client.rest_patch(@data['uri'], { 'body' => temp_data }, @api_version)
        @client.response_handler(response)
      end
      self
    end

    # Reapplies the enclosure configuration
    def configuration
      ensure_client && ensure_uri
      response = @client.rest_put(@data['uri'] + '/configuration', {}, @api_version)
      new_data = @client.response_handler(response)
      set_all(new_data)
    end


    # Refreshes the enclosure along with all of its components
    # @param [String] state NotRefreshing, RefreshFailed, RefreshPending, Refreshing
    # @param [Hash] options  Optional force fields for refreshing the enclosure
    def set_refresh_state(state, options = {})
      ensure_client && ensure_uri
      s = state.to_s rescue state
      requestBody = {
        'body' => {
          refreshState: s,
          refreshForceOptions: options
        }
      }
      response = @client.rest_put(@data['uri'] + '/refreshState', requestBody, @api_version)
      new_data = @client.response_handler(response)
      set_all(new_data)
    end

    # Gets the enclosure script content
    # @return [String] Script content
    def script
      ensure_client && ensure_uri
      response = @client.rest_get(@data['uri'] + '/script', @api_version)
      @client.response_handler(response)
    end

    # Gets the enclosure settings that describe the environmental configuration
    # @return [Hash] The enclosure envirnomental configuration
    def environmental_configuration
      ensure_client && ensure_uri
      response = @client.rest_get(@data['uri'] + '/environmentalConfiguration', @api_version)
      @client.response_handler(response)
    end

    # Retrieves historical utilization
    # @param [Hash] queryParameters query parameters (ie :startDate, :endDate, :fields, :view, etc.)
    # @option queryParameters [Array] :fields
    # @option queryParameters [Time, Date, String] :startDate
    # @option queryParameters [Time, Date, String] :endDate
    def utilization(queryParameters = {})
      ensure_client && ensure_uri
      uri = "#{@data['uri']}/utilization?"

      queryParameters[:endDate]   = convert_time(queryParameters[:endDate])
      queryParameters[:startDate] = convert_time(queryParameters[:startDate])

      queryParameters.each do |key, value|
        next if value.nil?
        uri += case key.to_sym
               when :fields
                 "fields=#{value.join(',')}"
               when :startDate, :endDate
                 "filter=#{key}=#{value}"
               else
                 "#{key}=#{value}"
               end
        uri += '&'
      end
      uri.chop! # Get rid of trailing '&' or '?'
      response = @client.rest_get(uri, @api_version)
      @client.response_handler(response)
    end

    # Updates specific attributes of a given enclosure resource
    # @param [String] operation operation to be performed
    # @param [String] path path
    # @param [String] value value
    def patch(operation, path, value)
      ensure_client && ensure_uri
      response = @client.rest_patch(@data['uri'], { 'body' => [{ op: operation, path: path, value: value }] }, @api_version)
      @client.response_handler(response)
    end

    # Associates an enclosure group to the enclosure
    # @param [OneviewSDK<Resource>] eg Enclosure Group associated
    def set_enclosure_group(eg)
      eg.retrieve! unless eg['uri']
      @data['enclosureGroupUri'] = eg['uri']
    end

    private

    # Converts Date, Time, or String objects to iso8601 string
    # @raise [InvalidResource] if time is not formatted correctly
    def convert_time(t)
      case t
      when nil then nil
      when Date then t.to_time.utc.iso8601(3)
      when Time then t.utc.iso8601(3)
      when String then Time.parse(t).utc.iso8601(3)
      else fail InvalidResource, "Invalid time format '#{t.class}'. Valid options are Time, Date, or String"
      end
    rescue StandardError => e
      raise InvalidResource, "Failed to parse time value '#{t}'. #{e.message}"
    end
  end
  end
end
