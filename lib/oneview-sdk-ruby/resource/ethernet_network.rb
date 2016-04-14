module OneviewSDK
  # Resource for ethernet networks
  # Common Data Attributes:
  #   category
  #   connectionTemplateUri
  #   created
  #   description
  #   eTag
  #   ethernetNetworkType
  #   fabricUri
  #   modified
  #   name (Required)
  #   privateNetwork (Required)
  #   purpose (Required)
  #   smartLink (Required)
  #   state
  #   status
  #   type (Required)
  #   vlanId (Required)
  class EthernetNetwork < Resource
    BASE_URI = '/rest/ethernet-networks'.freeze

    def initialize(client, params = {}, api_ver = nil)
      super
      # Default values:
      @data['ethernetNetworkType'] ||= 'Tagged'
      case @api_version
      when 120
        @data['type'] ||= 'ethernet-networkV2'
      when 200
        @data['type'] ||= 'ethernet-networkV3'
      end
    end

    # Bulk create ethernet networks
    # @param [Client] client client to connect with OneView
    # @param [Hash] options information necessary to create networks
    # @return [Array] list of ethernet networks created
    def self.bulk_create(client, options)
      range = options[:vlanIdRange].split('-').map { |x| x.to_i }
      options[:type] = 'bulk-ethernet-network'
      response = client.rest_post(BASE_URI + '/bulk', { 'body' => options }, client.api_version)
      client.response_handler(response)
      network_names = []
      range[0].upto(range[1]) { |i| network_names << "#{options[:namePrefix]}_#{i}" }
      OneviewSDK::EthernetNetwork.get_all(client).select { |network| network_names.include?(network['name']) }
    end

    # Get associatedProfiles
    def get_associated_profiles
      ensure_client && ensure_uri
      response = @client.rest_get("#{@data['uri']}/associatedProfiles", @api_version)
      response.body
    end

    # Get associatedUplinkGroups
    def get_associated_uplink_groups
      ensure_client && ensure_uri
      response = @client.rest_get("#{@data['uri']}/associatedUplinkGroups", @api_version)
      response.body
    end

    VALID_ETHERNET_NETWORK_TYPES = %w(NotApplicable Tagged Tunnel Unknown Untagged).freeze
    # Validate ethernetNetworkType
    # @param [String] value Notapplicable, Tagged, Tunnel, Unknown, Untagged
    def validate_ethernetNetworkType(value)
      fail 'Invalid network type' unless VALID_ETHERNET_NETWORK_TYPES.include?(value)
    end

    VALID_PURPOSES = %w(FaultTolerance General Management VMMigration).freeze
    # Validate purpose
    # @param [String] value FaultTolerance, General, Management, VMMigration
    def validate_purpose(value)
      fail 'Invalid ethernet purpose' unless VALID_PURPOSES.include?(value)
    end

  end
end
