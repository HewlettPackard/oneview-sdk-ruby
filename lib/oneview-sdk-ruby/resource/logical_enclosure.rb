module OneviewSDK
  # Resource for ethernet networks
  # Common Data Attributes:
  #   category
  #   created
  #   deleteFailed
  #   description
  #   eTag
  #   enclosureGroupUri
  #   enclosureUris
  #   enclosures
  #   firmware
  #   ipAddressingMode
  #   ipv4Ranges
  #   logicalInterconnectUris
  #   modified
  #   name
  #   powerMode
  #   state
  #   status
  #   type
  #   uri
  class LogicalEnclosure < Resource
    BASE_URI = '/rest/logical-enclosures'.freeze

    def initialize(client, params = {}, api_ver = nil)
      super
      # Default values
      @data['type'] ||= 'LogicalEnclosure'
    end

    # Reapplies the appliance's configuration on enclosures
    # @raise [RuntimeError] if the client is not set
    # @raise [RuntimeError] if the uri is not set
    # @raise [RuntimeError] if the reapply fails
    # @return [LogicalEnclosure] self
    def reconfigure
      ensure_client && ensure_uri
      response = @client.rest_put("#{@data['uri']}/configuration", {}, @api_version)
      @client.response_handler(response)
      self
    end

    # Makes this logical enclosure consistent with the enclosure group
    # @raise [RuntimeError] if the client is not set
    # @raise [RuntimeError] if the uri is not set
    # @raise [RuntimeError] if the process fails
    # @return [Resource] self
    def update_from_group
      ensure_client && ensure_uri
      response = @client.rest_put("#{@data['uri']}/updateFromGroup", {}, @api_version)
      @client.response_handler(response)
      self
    end

    # Get the configuration script
    # @raise [RuntimeError] if the client is not set
    # @raise [RuntimeError] if the uri is not set
    # @raise [RuntimeError] if retrieving fails
    # @return [String] script
    def get_script
      ensure_client && ensure_uri
      response = @client.rest_get("#{@data['uri']}/script", @api_version)
      response.body
    end

    # Updates the configuration script for the logical enclosure
    # @raise [RuntimeError] if the client is not set
    # @raise [RuntimeError] if the uri is not set
    # @raise [RuntimeError] if the reapply fails
    # @return [Resource] self
    def set_script(script)
      ensure_client && ensure_uri
      response = @client.rest_put("#{@data['uri']}/script", { 'body' => script }, @api_version)
      @client.response_handler(response)
      self
    end

    # Generates a support dump for the logical enclosure
    # @raise [RuntimeError] if the client is not set
    # @raise [RuntimeError] if the uri is not set
    # @raise [RuntimeError] if the process fails when generating the support dump
    # @return [Resource] self
    def support_dump(options)
      ensure_client && ensure_uri
      response = @client.rest_post("#{@data['uri']}/support-dumps", { 'body' => options }, @api_version)
      @client.wait_for(response.header['location'])
      self
    end

    VALID_FABRIC_TYPES = %w(DirectAttach FabricAttach).freeze
    # Validate fabricType
    # @param [String] value DirectAttach, FabricAttach
    # @raise [RuntimeError] if value is not 'DirectAttach' or 'FabricAttach'
    def validate_fabricType(value)
      fail 'Invalid fabric type' unless VALID_FABRIC_TYPES.include?(value)
    end

  end
end
