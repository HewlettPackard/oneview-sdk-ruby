# (C) Copyright 2016 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License.

require_relative '../../api200/san_manager'

module OneviewSDK
  module API300
    module C7000
      # SAN manager resource implementation
      class SANManager < OneviewSDK::API200::SANManager

        REQUIRED_FIELDS_TO_UPDATE = %w(Host Port Username Password UseSsl).freeze

        def update(options)
          options ||= {}
          if options.key? 'connectionInfo'
            result = validate_connection_info(options['connectionInfo'])
            raise IncompleteResource, "You must complete connectionInfo properties with #{result.join(', ')} values" unless result.empty?
          end

          super(options)
        end

        private

        def validate_connection_info(connectionInfo)
          required = REQUIRED_FIELDS_TO_UPDATE.dup
          keys = connectionInfo.map do |k|
            k['name'] if k.include?('name')
          end
          required.select { |a| !keys.include?(a) }
        end
      end
    end
  end
end
