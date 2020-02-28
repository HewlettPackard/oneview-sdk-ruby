# (C) Copyright 2020 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License.

require_relative '../api600/build_plan'

module OneviewSDK
  module ImageStreamer
    module API800
      # Build Plan resource implementation for Image Streamer
      class BuildPlan < OneviewSDK::ImageStreamer::API600::BuildPlan
      end
    end
  end
end
