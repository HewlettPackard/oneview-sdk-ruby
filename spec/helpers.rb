module Helpers
  def resource_class_of(resource_name)
    namespace = described_class.to_s[0, described_class.to_s.rindex('::')]
    Object.const_get("#{namespace}::#{resource_name}")
  end
end
