I3S_DEPENDENCIES = {
  BuildPlan: [:PlanScript],
  GoldenImage: [:OSVolume, :BuildPlan],
  OSVolume: [],
  PlanScript: []
}.freeze

I3S_SEQ = I3S_DEPENDENCIES.tsort
I3S_RSEQ = I3S_SEQ.reverse

# Get sequence number for the given class (Create sequence)
# @param [Class] klass
# @return [Integer] sequence number
def i3s_seq(klass)
  seq(klass, I3S_SEQ)
end

# Get inverse sequence number for the given class (Delete sequence)
# @param [Class] klass
# @return [Integer] sequence number
def i3s_rseq(klass)
  rseq(klass, I3S_RSEQ)
end

# Resource Names:

# Plan Script
PLAN_SCRIPT1_NAME = 'Plan_Script_1'.freeze
PLAN_SCRIPT2_NAME = 'Plan_Script_2'.freeze
PLAN_SCRIPT1_NAME_UPDATE = 'Plan_Script_1_Updated'.freeze

# Golden Image
GOLDEN_IMAGE1_NAME = 'Golden_Image_1'.freeze
GOLDEN_IMAGE2_NAME = 'Golden_Image_2'.freeze
GOLDEN_IMAGE1_NAME_UPDATE = 'Golden_Image_1_Updated'.freeze

# Build Plan
BUILD_PLAN1_NAME = 'Build_Plan_1'.freeze
BUILD_PLAN2_NAME = 'Build_Plan_2'.freeze
BUILD_PLAN3_NAME = 'Build_Plan_3'.freeze
BUILD_PLAN4_NAME = 'Build_Plan_4'.freeze
BUILD_PLAN1_NAME_UPDATED = 'Build_Plan_1_Updated'.freeze
