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

    def validate_licensingIntent(value)
      fail 'Invalid licensingIntent' unless %w(NotApplicable OneView OneViewNoiLO OneViewStandard).include?(value) || value.nil?
    end

  end
end
