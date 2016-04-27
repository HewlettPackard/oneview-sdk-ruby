require 'time'
require 'date'

module OneviewSDK
  # Resource for enclosure groups
  # Common Data Attributes:
  #   activeOaPreferredIP
  #   category
  #   created
  #   description
  #   deviceBayCount
  #   deviceBays
  #   eTag
  #   enclosureGroupUri (Required)
  #   enclosureModel
  #   enclosureTypeUri
  #   fanBayCount
  #   fanBays
  #   forceInstallFirmware
  #   fwBaselineName
  #   fwBaselineUri
  #   interconnectBayCount
  #   interconnectBays
  #   isFwManaged
  #   licensingIntent (Required)
  #   logicalEnclosureUri
  #   modified
  #   name
  #   oaBays
  #   partNumber
  #   powerSupplyBayCount
  #   powerSupplyBays
  #   rackName
  #   reconfigurationState
  #   refreshState
  #   serialNumber
  #   standbyOaPreferredIP
  #   state
  #   status
  #   type
  #   uidState
  #   uri
  #   vcmDomainId
  #   vcmDomainName
  #   vcmMode
  #   vcmUrl
  # Additional data attributes for adding an enclosure:
  #   hostname (Required)
  #   username (Required)
  #   password (Required)
  class Enclosure < Resource
    BASE_URI = '/rest/enclosures'.freeze

    def initialize(client, params = {}, api_ver = nil)
      super
      # Default values:
      @data['type'] ||= 'EnclosureV200'
    end

    # @!group Validates

    VALID_LICENSING_INTENTS = %w(NotApplicable OneView OneViewNoiLO OneViewStandard).freeze
    def validate_licensingIntent(value)
      fail 'Invalid licensingIntent' unless VALID_LICENSING_INTENTS.include?(value) || value.nil?
    end

    VALID_REFRESH_STATES = %w(NotRefreshing RefreshFailed RefreshPending Refreshing).freeze
    def validate_refreshState(value)
      fail 'Invalid refreshState' unless VALID_REFRESH_STATES.include?(value)
    end

    # @!endgroup

    # Claim/configure the enclosure and its components to the appliance
    def create
      ensure_client
      required_attributes = %w(enclosureGroupUri hostname username password licensingIntent)
      required_attributes.each { |k| fail "Missing required attribute: '#{k}'" unless @data.key?(k) }

      optional_attrs = %w(enclosureUri firmwareBaselineUri force forceInstallFirmware state unmanagedEnclosure updateFirmwareOn)
      temp_data = @data.select { |k, _v| required_attributes.include?(k) || optional_attrs.include?(k) }
      response = @client.rest_post(self.class::BASE_URI, { 'body' => temp_data }, @api_version)
      new_data = @client.response_handler(response)
      old_name = @data.select { |k, _v| %w(name rackName).include?(k) } # Save name (if given)
      %w(username password hostname).each { |k| @data.delete(k) } # These are no longer needed
      set_all(new_data)
      set_all(old_name)
      save
      self
    end

    # Override save operation because only the name and rackName can be updated (& it uses PATCH).
    def save
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

    # Reapply enclosure configuration
    def configuration
      ensure_client && ensure_uri
      response = @client.rest_put(@data['uri'] + '/configuration', {}, @api_version)
      new_data = @client.response_handler(response)
      set_all(new_data)
    end


    # Refresh enclosure along with all of its components
    # @param [String] state NotRefreshing, RefreshFailed, RefreshPending, Refreshing
    # @param [Hash] options  Optional force fields for refreshing the enclosure
    def set_refresh_state(state, options = {})
      ensure_client && ensure_uri
      s = state.to_s rescue state
      validate_refreshState(s) # Validate refreshState
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

    # Get enclosure script content
    # @return [String] Script content
    def script
      ensure_client && ensure_uri
      response = @client.rest_get(@data['uri'] + '/script', @api_version)
      @client.response_handler(response)
    end

    # Get settings that describe the environmental configuration
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

    # Update specific attributes of a given enclosure resource
    # @param [String] operation operation to be performed
    # @param [String] path path
    # @param [String] value value
    def update_attribute(operation, path, value)
      ensure_client && ensure_uri
      response = @client.rest_patch(@data['uri'], { 'body' => [{ op: operation, path: path, value: value }] }, @api_version)
      @client.response_handler(response)
    end

    # Associates one Enclosure Group to the enclosure to be added
    # @param [OneviewSDK<Resource>] eg Enclosure Group associated
    def set_enclosure_group(eg)
      eg.retrieve! unless eg['uri']
      @data['enclosureGroupUri'] = eg['uri']
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
