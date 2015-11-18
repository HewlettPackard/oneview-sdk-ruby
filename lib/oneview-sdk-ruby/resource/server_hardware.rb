
module OneviewSDK
  # Resource for server hardware
  # Common Data Attributes:
  #   activeOaPreferredIP
  #   assetTag
  #   category
  #   description
  #   deviceBayCount
  #   deviceBays
  #   eTag
  #   enclosureGroupUri
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
  #   licensingIntent
  #   logicalEnclosureUri
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
  #   stateReason
  #   status
  #   type
  #   uidState
  #   uri
  #   uuid
  #   vcmDomainId
  #   vcmDomainName
  #   vcmMode
  #   vcmUrl
  # Additional data attributes for adding an enclosure:
  #   hostname (Required)
  #   username (Required)
  #   password (Required)
  #   licensingIntent (Required)
  #   configurationState
  class ServerHardware < Resource
    BASE_URI = '/rest/server-hardware'

    def initialize(client, params = {}, api_ver = nil)
      super
      # Default values
      case @api_version
      when 120
        @data['type'] ||= 'server-hardware-3'
      when 200
        @data['type'] ||= 'server-hardware-4'
      end
    end

    def create
      ensure_client
      required_attributes = %w(hostname username password licensingIntent)
      required_attributes.each { |k| fail "Missing required attribute: '#{k}'" unless @data.key?(k) }

      optional_attrs = %w(configurationState force restore)
      temp_data = @data.select { |k, _v| required_attributes.include?(k) || optional_attrs.include?(k) }
      response = @client.rest_post(self.class::BASE_URI, { 'body' => temp_data }, @api_version)
      body = @client.response_handler(response)
      set_all(body)
      %w(username password hostname).each { |k| @data.delete(k) } # These are no longer needed
      self
    end

    def save
      @logger.error 'ServerHardware resources cannot be updated!'
      false
    end

    def update(*)
      save
    end

    def validate_licensingIntent(value)
      fail 'Invalid licensingIntent' unless %w(OneView OneViewNoiLO OneViewStandard).include?(value) || value.nil?
    end

    def validate_configurationState(value)
      fail 'Invalid configurationState' unless %w(Managed Monitored).include?(value) || value.nil?
    end

  end
end
