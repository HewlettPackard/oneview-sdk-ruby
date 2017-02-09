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

require_relative 'resource'

module OneviewSDK
  module ImageStreamer
    module API300
      # Build Plan resource implementation for Image Streamer
      # @note This resource is unimplemented/unfinished at this point, so use at your own risk.
      #   This resource is subject to change drastically in the near future without a major version
      #   bump, which may break your code.
      class BuildPlan < Resource
        BASE_URI = '/rest/build-plans'.freeze
      end
    end
  end
end
