Dir[File.dirname(__FILE__) + '/client/*.rb'].each {|file| require file }

module OneviewSDK
  class Client
    include EthernetNetwork
  end
end
