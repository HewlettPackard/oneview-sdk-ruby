
module OneviewSDK
  class Client
    module EthernetNetwork
    
	  def create_ethernet_network(resource)
        requestBody = {}
	    requestBody[:name]    = resource.name
	    requestBody[:purpose] = resource.purpose
	    requestBody[:vlanId]  = resource.vlanId

	    puts requestBody.to_s
	  end
    
	  def delete_ethernet_network(resource)
	  end
    end
  end
end
