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
  module API200
    # Server hardware resource implementation
    class ServerHardware < Resource
      BASE_URI = '/rest/server-hardware'.freeze
      UNIQUE_IDENTIFIERS = %w[name uri serialNumber virtualSerialNumber serverProfileUri].freeze

      # Remove resource from OneView
      # @return [true] if resource was removed successfully
      alias remove delete

      # Create a resource object, associate it with a client, and set its properties.
      # @param [OneviewSDK::Client] client The client object for the OneView appliance
      # @param [Hash] params The options for this resource (key-value pairs)
      # @param [Integer] api_ver The api version to use when interracting with this resource.
      def initialize(client, params = {}, api_ver = nil)
        super
        # Default values
        @data['type'] ||= 'server-hardware-4'
      end

      # Retrieve resource details based on this resource's name or URI.
      # @note one of the UNIQUE_IDENTIFIERS must be specified in the resource
      # @return [Boolean] Whether or not retrieve was successful
      def retrieve!
        hostname = @data['hostname'] || @data['mpHostInfo']['mpHostName'] rescue nil
        if hostname
          results = self.class.find_by(@client, 'mpHostInfo' => { 'mpHostName' => hostname })
          if results.size == 1
            set_all(results[0].data)
            return true
          end
        end
        super
      rescue IncompleteResource => e
        raise e unless hostname
        false
      end

      # Check if a resource exists
      # @note one of the UNIQUE_IDENTIFIERS must be specified in the resource
      # @return [Boolean] Whether or not resource exists
      def exists?
        hostname = @data['hostname'] || @data['mpHostInfo']['mpHostName'] rescue nil
        return true if hostname && self.class.find_by(@client, 'mpHostInfo' => { 'mpHostName' => hostname }).size == 1
        super
      rescue IncompleteResource => e
        raise e unless hostname
        false
      end

      # Method is not available
      # @raise [OneviewSDK::MethodUnavailable] method is not available
      def create(*)
        unavailable_method
      end

      # Method is not available
      # @raise [OneviewSDK::MethodUnavailable] method is not available
      def delete(*)
        unavailable_method
      end

      # Adds the resource on OneView using the current data
      # @raise [OneviewSDK::IncompleteResource] if the client is not set or required attributes are missing
      # @return [OneviewSDK::ServerHardware] self
      def add
        ensure_client
        required_attributes = %w[hostname username password licensingIntent]
        required_attributes.each { |k| raise IncompleteResource, "Missing required attribute: '#{k}'" unless @data.key?(k) }

        optional_attrs = %w[configurationState force restore]
        temp_data = @data.select { |k, _v| required_attributes.include?(k) || optional_attrs.include?(k) }
        response = @client.rest_post(self.class::BASE_URI, { 'body' => temp_data }, @api_version)
        body = @client.response_handler(response)
        set_all(body)
        %w[username password hostname].each { |k| @data.delete(k) } # These are no longer needed
        self
      end

      # Method is not available
      # @raise [OneviewSDK::MethodUnavailable] method is not available
      def update(*)
        unavailable_method
      end

      # Power on the server hardware
      # @param [Boolean] force Use 'PressAndHold' action?
      # @return [Boolean] Returns whether or not the server was powered on
      def power_on(force = false)
        set_power_state('on', force)
      end

      # Power off the server hardware
      # @param [Boolean] force Use 'PressAndHold' action?
      # @return [Boolean] Returns whether or not the server was powered off
      def power_off(force = false)
        set_power_state('off', force)
      end

      # Gets a list of BIOS/UEFI values on the physical server
      # @return [Hash] List with BIOS/UEFI settings
      def get_bios
        response = @client.rest_get(@data['uri'] + '/bios')
        @client.response_handler(response)
      end

      # Gets a url to the iLO web interface
      # @return [Hash] url
      def get_ilo_sso_url
        response = @client.rest_get(@data['uri'] + '/iloSsoUrl')
        @client.response_handler(response)
      end

      # Gets a Single Sign-On session for the Java Applet console
      # @return [Hash] url
      def get_java_remote_sso_url
        response = @client.rest_get(@data['uri'] + '/javaRemoteConsoleUrl')
        @client.response_handler(response)
      end

      # Gets a url to the iLO web interface
      # @return [Hash] url
      def get_remote_console_url
        response = @client.rest_get(@data['uri'] + '/remoteConsoleUrl')
        @client.response_handler(response)
      end

      # Refreshes the enclosure along with all of its components
      # @param [String] state NotRefreshing, RefreshFailed, RefreshPending, Refreshing
      # @param [Hash] options  Optional force fields for refreshing the enclosure
      def set_refresh_state(state, options = {})
        ensure_client && ensure_uri
        s = state.to_s rescue state
        requestBody = {
          'body' => {
            refreshState: s
          }
        }
        requestBody['body'].merge(options)
        response = @client.rest_put(@data['uri'] + '/refreshState', requestBody, @api_version)
        new_data = @client.response_handler(response)
        set_all(new_data)
      end

      # Updates the iLO firmware on a physical server to a minimum iLO firmware required by OneView
      def update_ilo_firmware
        response = @client.rest_put(@data['uri'] + '/mpFirmwareVersion')
        @client.response_handler(response)
      end

      # Gets the settings that describe the environmental configuration
      def environmental_configuration
        ensure_client && ensure_uri
        response = @client.rest_get(@data['uri'] + '/environmentalConfiguration', {}, @api_version)
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
        response = @client.rest_get(uri, {}, @api_version)
        @client.response_handler(response)
      end

      private

      # Converts Date, Time, or String objects to iso8601 string
      def convert_time(t)
        case t
        when nil then nil
        when Date then t.to_time.utc.iso8601(3)
        when Time then t.utc.iso8601(3)
        when String then Time.parse(t).utc.iso8601(3)
        else raise InvalidResource, "Invalid time format '#{t.class}'. Valid options are Time, Date, or String"
        end
      rescue StandardError => e
        raise InvalidResource, "Failed to parse time value '#{t}'. #{e.message}"
      end

      # Set power state. Takes into consideration the current state and does the right thing
      def set_power_state(state, force)
        refresh
        return true if @data['powerState'].downcase == state
        @logger.debug "Powering #{state} server hardware '#{@data['name']}'. Current state: '#{@data['powerState']}'"

        action = 'PressAndHold' if force
        action ||= case @data['powerState'].downcase
                   when 'poweringon', 'poweringoff' # Wait
                     sleep 5
                     return set_power_state(state, force)
                   when 'resetting'
                     if state == 'on' # Wait
                       sleep 5
                       return set_power_state(state, force)
                     end
                     'PressAndHold'
                   when 'unknown' then state == 'on' ? 'ColdBoot' : 'PressAndHold'
                   else 'MomentaryPress'
                   end
        options = { 'body' => { powerState: state.capitalize, powerControl: action } }
        response = @client.rest_put("#{@data['uri']}/powerState", options)
        body = @client.response_handler(response)
        set_all(body)
        true
      end
    end
  end
end
