require_relative 'rest'
Dir[File.dirname(__FILE__) + '/client/*.rb'].each {|file| require file }

module OneviewSDK
  class Client
    include Rest
	include EthernetNetwork
    
  end
end
