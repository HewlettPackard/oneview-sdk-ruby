module OneviewSDK
  # Resource for storage system
  # Common Data Attributes:
  #   allocatedCapacity
  #   category
  #   created
  #   credentials
  #   description
  #   eTag
  #   firmware
  #   freeCapacity
  #   managedDomain
  #   managedPools
  #   managedPorts
  #   model
  #   modified
  #   name
  #   refreshState
  #   serialNumber
  #   state
  #   stateReason
  #   status
  #   totalCapacity
  #   type
  #   unmanagedDomains
  #   unmanagedPools
  #   unmanagedPorts
  #   uri
  #   wwn
  class StorageSystem < Resource
    BASE_URI = '/rest/storage-systems'.freeze

    def initialize(client, params = {}, api_ver = nil)
      super
      # Default values:
      case @api_version
      when 120
        @data['type'] ||= 'StorageSystemV2'
      when 200
        @data['type'] ||= 'StorageSystemV3'
      end
    end

    def create
      ensure_client
      task = @client.rest_post(self.class::BASE_URI, { 'body' => @data['credentials'] }, @api_version)
      temp = @data.clone
      task = @client.wait_for(task['uri'] || task['location'])
      @data['uri'] = task['associatedResource']['resourceUri']
      refresh
      temp.delete('credentials')
      update(temp)
      self
    end

    def retrieve!
      if @data['name']
        super
      else
        results = self.class.find_by(@client, credentials: { ip_hostname: @data['credentials'][:ip_hostname] })
        return false unless results.size == 1
        set_all(results[0].data)
        true
      end
    end

    # Get host types for storage system resource
    # @param [Client] client client handle REST calls to OV instance
    # @return [String] response body
    def self.host_types(client)
      response = client.rest_get(BASE_URI + '/host-types')
      response.body
    end

    # List of storage pools
    def storage_pools
      response = @client.rest_get(@data['uri'] + '/storage-pools')
      response.body
    end

    # List of all managed target ports for the specified storage system
    # or only the one specified
    # @param [String] port Target port
    def managedPorts(port = nil)
      response = if port.nil?
                   @client.rest_get(@data['uri'] + '/managedPorts')
                 else
                   @client.rest_get(@data['uri'] + 'managedPorts/' + port)
                 end
      response.body
    end

  end
end
