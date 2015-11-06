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
    BASE_URI = '/rest/storage-systems'

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

    def retrieve!(name = @data['name'], credentials = @data['credentials'])
      if name.nil?
        results = self.class.find_by(@client, credentials: { ip_hostname: credentials[:ip_hostname] })
        return false unless results.size == 1
        set_all(results[0].data)
        true
      else
        super.retrieve!
      end
    end

  end
end
