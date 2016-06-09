module OneviewSDK
  # Server hardware resource implementation
  class ServerHardware < Resource
    BASE_URI = '/rest/server-hardware'.freeze

    def initialize(client, params = {}, api_ver = nil)
      super
      # Default values
      @data['type'] ||= 'server-hardware-4'
    end

    # @!group Validates

    VALID_LICENSING_INTENTS = ['OneView', 'OneViewNoiLO', 'OneViewStandard', nil].freeze
    def validate_licensingIntent(value)
      fail 'Invalid licensingIntent' unless VALID_LICENSING_INTENTS.include?(value)
    end

    VALID_CONFIGURATION_STATES = ['Managed', 'Monitored', nil].freeze
    def validate_configurationState(value)
      fail 'Invalid configurationState' unless VALID_CONFIGURATION_STATES.include?(value)
    end

    VALID_REFRESH_STATES = %w(NotRefreshing RefreshFailed RefreshPending Refreshing).freeze
    def validate_refreshState(value)
      fail 'Invalid refreshState' unless VALID_REFRESH_STATES.include?(value)
    end

    # @!endgroup

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

    # unavailable method
    def update(*)
      unavailable_method
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

    # Get list of BIOS/UEFI values on the physical server
    # @return [Hash] List with BIOS/UEFI settings
    def get_bios
      response = @client.rest_get(@data['uri'] + '/bios')
      @client.response_handler(response)
    end


    # Get a url to the iLO web interface
    # @return [String] url
    def get_ilo_sso_url
      response = @client.rest_get(@data['uri'] + '/iloSsoUrl')
      @client.response_handler(response)
    end

    # Get a Single Sign-On session for the Java Applet console
    # @return [String] url
    def get_java_remote_sso_url
      response = @client.rest_get(@data['uri'] + '/javaRemoteConsoleUrl')
      @client.response_handler(response)
    end

    # Get a url to the iLO web interface
    # @return [String] url
    def get_remote_console_url
      response = @client.rest_get(@data['uri'] + '/remoteConsoleUrl')
      @client.response_handler(response)
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
          refreshState: s
        }
      }
      requestBody['body'].merge(options)
      response = @client.rest_put(@data['uri'] + '/refreshState', requestBody, @api_version)
      new_data = @client.response_handler(response)
      set_all(new_data)
    end

    # Updates the iLO firmware on a physical server to a minimum ILO firmware required by OneView
    def update_ilo_firmware
      response = @client.rest_put(@data['uri'] + '/mpFirmwareVersion')
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
