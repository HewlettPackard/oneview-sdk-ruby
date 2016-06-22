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
  # Power device resource implementation
  class PowerDevice < Resource
    BASE_URI = '/rest/power-devices'.freeze

    alias add create
    alias remove delete

    def initialize(client, params = {}, api_ver = nil)
      super
      # Default values
      @data['deviceType'] ||= 'BranchCircuit'
      @data['phaseType'] ||= 'Unknown'
      @data['powerConnections'] ||= []
    end

    # @!group Validates

    VALID_RATED_CAPACITY = (0..9999).freeze
    def validate_ratedCapacity(value)
      fail 'Rated capacity out of range 0..9999' unless VALID_RATED_CAPACITY.include?(value)
    end

    VALID_REFRESH_STATE = %w(NotRefreshing RefreshFailed RefreshPending Refreshing).freeze
    def validate_refreshState(value)
      fail 'Invalid refresh state' unless VALID_REFRESH_STATE.include?(value)
    end

    # @!endgroup

    def create
      unavailable_method
    end

    def delete
      unavailable_method
    end

    # Add HP iPDU and bring all components under management by discovery of its management modules
    # @param [OneviewSDK::Client] client HPE OneView client
    # @param [Hash] options options for HP iPDU
    # @return [OneviewSDK::PowerDevice] iPDU power device created in OneView
    def self.discover(client, options)
      options['force'] ||= options[:force] || false
      response = client.rest_post(BASE_URI + '/discover', 'body' => options)
      power_device_info = client.response_handler(response)
      new(client, power_device_info)
    end

    # Retrieve list of power devices given an iPDU hostname
    # @param [OneviewSDK::Client] client HPE OneView client
    # @param [String] hostname iPDU hostname
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

    # Add power connection
    # @param [OneviewSDK::Resource] resource
    # @param [Integer] connection connection number
    def add_connection(resource, connection)
      @data['powerConnections'] << {
        'connectionUri' => resource['uri'],
        'deviceConnection' => connection,
        'sourceConnection' => connection
      }
    end

    # Remove power connection
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
      fail 'Invalid power state' if state != 'On' && state != 'Off'
      response = @client.rest_put(@data['uri'] + '/powerState', 'body' => { powerState: state })
      @client.response_handler(response)
    end

    # Refreshes a power delivery device
    # @param [Hash] options
    # @option options [String] :refreshState
    # @option options [String] :username
    # @option options [String] :password
    def set_refresh_state(options)
      state = options[:refreshState] || options['refreshState']
      validate_refreshState(state)
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

    # Convert Date, Time, or String objects to iso8601 string
    def convert_time(t)
      case t
      when nil then nil
      when Date then t.to_time.utc.iso8601(3)
      when Time then t.utc.iso8601(3)
      when String then Time.parse(t).utc.iso8601(3)
      else fail "Invalid time format '#{t.class}'. Valid options are Time, Date, or String"
      end
    rescue StandardError => e
      raise "Failed to parse time value '#{t}'. #{e.message}"
    end
  end
end
