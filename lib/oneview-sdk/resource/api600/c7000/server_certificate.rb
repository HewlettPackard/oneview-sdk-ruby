#(C) Copyright 2017 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License.

require_relative 'resource'

module OneviewSDK
    module API600
	    module C7000
		    class ServerCertificate < Resource
			    # Server certificate resource implementation
                            BASE_URI = '/rest/certificates/servers'.freeze
                            DEFAULT_REQUEST_HEADER = { 'requestername' => 'DEFAULT' }.freeze
                           
			    alias remove delete

                            def initialize(client, param = {}, api_ver = nil)
				    super
                                    #Default values
#				    @data['uri'] ||= "#{self.class::BASE_URI}/#{@data["aliasName"]}" if @data["aliasName"]
                                    @data["type"] ||= "CertificateInfoV2"
			    end
			    
			    def import
				    @data.delete("aliasName")
				    create(header = self.class::DEFAULT_REQUEST_HEADER)
				    true
                            end

			    def delete(*)
				    unavailable_method
			    end
			    def retrieve!
				    response = @client.rest_get(self.class::BASE_URI + "/#{@data["aliasName"]}")
				    body = @client.response_handler(response)
				    set_all(body)
			    	    true
			    end
			    
			    def remove
			    	    response = @client.rest_delete(self.class::BASE_URI + "/#{@data["aliasName"]}")
			    	    body = @client.response_handler(response)
			    	    true
			    end
			    
		    end
	    end
    end
end
