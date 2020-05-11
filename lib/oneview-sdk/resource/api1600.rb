# (c) Copyright 2020 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License.

module OneviewSDK
  # Module for API v1600
  module API1600
    SUPPORTED_VARIANTS = %w[C7000 Synergy].freeze
    DEFAULT_VARIANT = 'C7000'.freeze
    @variant = DEFAULT_VARIANT
    @variant_updated = false # Whether or not the API variant has been set by the user

    # Get resource class that matches the type given
    # @param [String] type Name of the desired class type
    # @param [String] variant Variant (C7000 or Synergy)
    # @return [Class] Resource class or nil if not found
    def self.resource_named(type, variant = @variant)
      raise "API1600 variant '#{variant}' is not supported! Try one of #{SUPPORTED_VARIANTS}" unless SUPPORTED_VARIANTS.include?(variant.to_s)
      new_type = type.to_s.downcase.gsub(/[ -_]/, '')
      api_module = OneviewSDK::API1600.const_get(variant)
      api_module.constants.each do |c|
        klass = api_module.const_get(c)
        next unless klass.is_a?(Class)
        name = klass.name.split('::').last.downcase.delete('_').delete('-')
        return klass if new_type =~ /^#{name}[s]?$/
      end
      nil
    end

    # Get the current API1600 variant
    def self.variant
      @variant
    end

    # Has the API1600 variant been set by the user?
    # @return [TrueClass, FalseClass]
    def self.variant_updated?
      @variant_updated
    end

    # Sets the API1600 variant
    def self.variant=(variant)
      raise "API1600 variant '#{variant}' is not supported! Try one of #{SUPPORTED_VARIANTS}" unless SUPPORTED_VARIANTS.include?(variant)
      @variant_updated = true
      @variant = variant
    end

    # Helps redirect resources to the correct API1600 variant
    def self.const_missing(const)
      api1600_module = OneviewSDK::API1600.const_get(@variant.to_s)
      api1600_module.const_get(const)
    rescue NameError
      raise NameError, "The #{const} method or resource does not exist for OneView API1600 variant #{@variant}."
    end
  end
end

# Load all API1600-specific resources:
Dir[File.dirname(__FILE__) + '/api1600/*.rb'].each { |file| require file }
