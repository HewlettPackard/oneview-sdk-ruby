
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
    BASE_URI = '/rest/server-hardware'.freeze

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

    # Power on the server hardware
    # @param [String] force Use 'PressAndHold' action
    # @return [Boolean] Whether or not server was powered on
    def power_on(force = false)
      set_power_state('on', force)
    end

    # Power off the server hardware
    # @param [String] force Use 'PressAndHold' action
    # @return [Boolean] Whether or not server was powered off
    def power_off(force = false)
      set_power_state('off', force)
    end

    VALID_LICENSING_INTENTS = ['OneView', 'OneViewNoiLO', 'OneViewStandard', nil].freeze
    def validate_licensingIntent(value)
      fail 'Invalid licensingIntent' unless VALID_LICENSING_INTENTS.include?(value)
    end

    VALID_CONFIGURATION_STATES = ['Managed', 'Monitored', nil].freeze
    def validate_configurationState(value)
      fail 'Invalid configurationState' unless VALID_CONFIGURATION_STATES.include?(value)
    end

    private

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
