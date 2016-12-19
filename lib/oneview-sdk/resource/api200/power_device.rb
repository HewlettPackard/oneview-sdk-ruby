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
    # Power device resource implementation
    class PowerDevice < Resource
      BASE_URI = '/rest/power-devices'.freeze

      # Add the resource on OneView using the current data
      # @note Calls the refresh method to set additional data
      # @raise [OneviewSDK::IncompleteResource] if the client is not set
      # @raise [StandardError] if the resource creation fails
      # @return [OneviewSDK::PowerDevice] self
      alias add create

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
        @data['deviceType'] ||= 'BranchCircuit'
        @data['phaseType'] ||= 'Unknown'
        @data['powerConnections'] ||= []
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

      # Adds an iPDU and bring all components under management by discovery of its management modules
      # @param [OneviewSDK::Client] client The client object for the OneView appliance
      # @param [Hash] options options for the iPDU
      # @return [OneviewSDK::PowerDevice] The iPDU power device created in OneView
      def self.discover(client, options)
        options['force'] ||= options[:force] || false
        response = client.rest_post(BASE_URI + '/discover', 'body' => options)
        power_device_info = client.response_handler(response)
        new(client, power_device_info)
      end

      # Retrieves the list of power devices given an iPDU hostname
      # @param [OneviewSDK::Client] client The client object for the OneView appliance
      # @param [String] hostname The iPDU hostname
      # @return [Array] array of OneviewSDK::PowerDevice
      def self.get_ipdu_devices(client, hostname)
        find_by(client, managedBy: { hostName: hostname })
      end

      # Gets the power state of a power device
      # @return [String] Power state
      def get_power_state
        response = @client.rest_get(@data['uri'] + '/powerState')
        response.body
      end

      # Adds a power connection
      # @param [OneviewSDK::Resource] resource
      # @param [Integer] connection connection number
      def add_connection(resource, connection)
        @data['powerConnections'] << {
          'connectionUri' => resource['uri'],
          'deviceConnection' => connection,
          'sourceConnection' => connection
        }
      end

      # Removes the power connection
      # @param [OneviewSDK::Resource] resource
      # @param [Integer] connection connection number
      def remove_connection(resource, connection)
        @data['powerConnections'].reject! do |conn|
          conn['connectionUri'] == resource['uri'] && conn['deviceConnection'] == connection
        end
      end

      # Sets the power state of the power delivery device
      # @param [String] state On|Off
      def set_power_state(state)
        response = @client.rest_put(@data['uri'] + '/powerState', 'body' => { powerState: state })
        @client.response_handler(response)
      end

      # Refreshes a power delivery device
      # @param [Hash] options
      # @option options [String] :refreshState
      # @option options [String] :username
      # @option options [String] :password
      def set_refresh_state(options)
        response = @client.rest_put(@data['uri'] + '/refreshState', 'body' => options)
        @client.response_handler(response)
      end

      # Retrieves the unit identification state of the specified power outlet
      # @return [String] Uid state
      def get_uid_state
        response = @client.rest_get(@data['uri'] + '/uidState')
        response.body
      end

      # Sets the unit identification light state of the power delivery device
      # @param [String] state On|Off
      def set_uid_state(state)
        response = @client.rest_put(@data['uri'] + '/uidState', 'body' => { uidState: state })
        @client.response_handler(response)
      end

      # Retrieves historical utilization
      # @param [Hash] queryParameters query parameters (ie :startDate, :endDate, :fields, :view, etc.)
      # @option queryParameters [Array] :fields
      # @option queryParameters [Time, Date, String] :startDate
      # @option queryParameters [Time, Date, String] :endDate
      # @return [Hash] Utilization data
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

      private

      # Converts Date, Time, or String objects to iso8601 string
      def convert_time(t)
        case t
        when nil then nil
        when Date then t.to_time.utc.iso8601(3)
        when Time then t.utc.iso8601(3)
        when String then Time.parse(t).utc.iso8601(3)
        else raise "Invalid time format '#{t.class}'. Valid options are Time, Date, or String"
        end
      rescue StandardError => e
        raise "Failed to parse time value '#{t}'. #{e.message}"
      end
    end
  end
end
