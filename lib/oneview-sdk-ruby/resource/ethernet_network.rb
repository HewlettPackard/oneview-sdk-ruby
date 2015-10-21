
module OneviewSDK
  module Resource
    class EthernetNetwork
	  attr_accessor \
	    :name,
	    :vlanId,
	    :purpose,
	    :smartLink,
	    :privateNetwork,
	    :ethernetNetworkType,
	    :type,
	    :connectionTemplateUri

	  def initialize( params )
	    params.each do |key, value|
	      instance_variable_set("@#{key}", value)
	    end
	  end
    end
  end
end
