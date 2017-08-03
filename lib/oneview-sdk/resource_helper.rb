# (C) Copyright 2017 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License.

module OneviewSDK
  # Contains helper methods to include certain functionalities on resources
  module ResourceHelper
    # Performs a specific patch operation for the given resource.
    # If the resource supports the particular operation, the operation is performed
    # and a response is returned to the caller with the results.
    # @param [String] operation The operation to be performed
    # @param [String] path The path of operation
    # @param [String] value The value
    # @note This attribute is subject to incompatible changes in future release versions, including redefinition or removal.
    def patch(operation, path, value = nil, header_options = {})
      ensure_client && ensure_uri
      options = { 'body' => [op: operation, path: path, value: value] }
      options = options.merge(header_options)
      response = @client.rest_patch(@data['uri'], options, @api_version)
      @client.response_handler(response)
    end
  end
end
