require 'time'

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
      case @api_version
      when 120
        @data['type'] ||= 'EnclosureV2'
      when 200
        @data['type'] ||= 'EnclosureV200'
      end
    end

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
      response = @client.rest_put(@data['uri'] + '/configuration')
      new_data = @client.response_handler(response)
      set_all(new_data)
    end

    # Refresh enclosure along with all of its components
    # @param [String] state NotRefreshing, RefreshFailed, RefreshPending, Refreshing
    # @param [Hash] options  Optional force fields for refreshing the enclosure
    def refreshState(state, options = {})
      fail 'Invalid refreshState' unless %w(NotRefreshing RefreshFailed RefreshPending Refreshing).include?(state)
      requestBody = {
        'body' => {
          refreshState: state,
          refreshForceOptions: options
        }
      }
      response = @client.rest_put(@data['uri'] + '/refreshState', requestBody)
      new_data = @client.response_handler(response)
      set_all(new_data)
    end

    # Enclosure script
    def script
      response = @client.rest_get(@data['uri'] + '/script')
      @client.response_handler(response)
    end

    # Get settings that describe the environmental configuration
    def environmentalConfiguration
      response = @client.rest_get(@data['uri'] + '/environmentalConfiguration')
      @client.response_handler(response)
    end

    # Retrieves historical utilization
    # @param [Hash] queryParameters query parameters
    def utilization(queryParameters = {})
      uri = "#{@data['uri']}/utilization?"

      endDate = Time.iso8601(queryParameters[:endDate]) if queryParameters[:endDate]
      startDate = queryParameters[:startDate]

      # If the user provided an endDate and no startDate, then the startDate should be
      # automatically calculated
      if endDate && startDate.nil?
        queryParameters[:startDate] = (endDate - 86_400).iso8601(3)
      end

      queryParameters.each do |key, value|
        uri += if key.to_sym == :fields
                 "fields=#{value.join(',')}"
               elsif key.to_sym == :startDate || key.to_sym == :endDate
                 "filter=#{key}=#{value}"
               else
                 "#{key}=#{value}"
               end
        uri += '&'
      end
      uri.chop!
      response = @client.rest_get(uri)
      @client.response_handler(response)
    end

    # Update specific attributes of a given enclosure resource
    # @param [String] operation operation to be performed
    # @param [String] path path
    # @param [String] value value
    def updateAttribute(operation, path, value)
      response = @client.rest_patch(@data['uri'], 'body' => [{ op: operation, path: path, value: value }])
      @client.response_handler(response)
    end

    def validate_licensingIntent(value)
      fail 'Invalid licensingIntent' unless %w(NotApplicable OneView OneViewNoiLO OneViewStandard).include?(value) || value.nil?
    end

  end
end
