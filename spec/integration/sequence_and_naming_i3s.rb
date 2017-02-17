I3S_DEPENDENCIES = {
  PlanScripts: [],
  DeploymentGroup: [],
  ArtifactBundle: [:DeploymentGroup]
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

# Plan Scripts
PLAN_SCRIPT1_NAME = 'Plan_Script_1'.freeze
PLAN_SCRIPT1_NAME_UPDATE = 'Plan_Script_1_Updated'.freeze

# Artifact Bundle
ARTIFACT_BUNDLE1_NAME = 'Artifact_Bundle_1'.freeze
ARTIFACT_BUNDLE2_NAME = 'Artifact_Bundle_ReadOnly'.freeze

# Deployment Plans
DEPLOYMENT_PLAN1_NAME = 'CLRM_DP_withoutpwd'.freeze
