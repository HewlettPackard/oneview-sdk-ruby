# (C) Copyright 2017 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.

RSpec.shared_examples 'ScopeHelperMethodsExample' do |scope_class|

  let(:scope_clean) { scope_class.new(current_client) }
  let(:scope_1) { scope_class.get_all(current_client)[0] }
  let(:scope_2) { scope_class.get_all(current_client)[1] }

  describe '#add_scope' do
    context 'when scope has no URI' do
      it { expect { item.add_scope(scope_clean) }.to raise_error(OneviewSDK::IncompleteResource) }
    end

    it 'should add scope' do
      item.retrieve!
      expect { item.add_scope(scope_1) }.to_not raise_error
      item.retrieve!
      expect(item['scopeUris']).to match_array([scope_1['uri']])
    end
  end

  describe '#replace_scopes' do
    context 'when scope has no URI' do
      it { expect { item.replace_scopes(scope_clean) }.to raise_error(OneviewSDK::IncompleteResource) }
    end

    it 'should replace the list of scopes' do
      item.retrieve!
      expect { item.replace_scopes(scope_1, scope_2) }.to_not raise_error
      item.retrieve!
      expect(item['scopeUris']).to match_array([scope_1['uri'], scope_2['uri']])
    end
  end

  describe '#remove_scope' do
    context 'when scope has no URI' do
      it { expect { item.remove_scope(scope_clean) }.to raise_error(OneviewSDK::IncompleteResource) }
    end

    it 'should remove scope' do
      item.retrieve!
      expect { item.remove_scope(scope_2) }.to_not raise_error
      item.retrieve!
      expect(item['scopeUris']).to match_array([scope_1['uri']]) # scope_2 was removed

      expect { item.remove_scope(scope_1) }.to_not raise_error
      item.retrieve!
      expect(item['scopeUris']).to be_empty
    end
  end
end
