require 'spec_helper'

RSpec.describe OneviewSDK::ImageStreamer::API300::ArtifactsBundle do
  include_context 'shared context'

  subject(:artifact_bundle) { described_class.new(@client_i3s_300) }

  describe '::BASE_URI' do
    it { expect(described_class::BASE_URI).to eq('/rest/artifact-bundles') }

    it 'can not be modified' do
      expect { described_class::BASE_URI << 'some string' }.to raise_error(/can't modify frozen String/)
    end
  end

  describe '::BACKUPS_URI' do
    it { expect(described_class::BACKUPS_URI).to eq('/rest/artifact-bundles/backups') }

    it 'can not be modified' do
      expect { described_class::BACKUPS_URI << 'some string' }.to raise_error(/can't modify frozen String/)
    end
  end

  describe '::create_from_file' do
    it 'fails if the file does not exist' do
      expect { described_class.create_from_file(@client_i3s_300, 'file.fake', 'Artifact Name') }.to raise_error(OneviewSDK::NotFound)
    end

    it 'should return a self resource' do
      allow_any_instance_of(Net::HTTP).to receive(:request).and_return(FakeResponse.new({}, 200))
      allow_any_instance_of(Net::HTTP).to receive(:connect).and_return(true)
      allow(@client_i3s_300).to receive(:response_handler).and_return({ 'members' => { uri: '/rest/artifact-bundles/1' } })
      allow(File).to receive(:file?).and_return(true)
      allow(File).to receive(:open).with('file.zip').and_yield('FAKE FILE CONTENT')
      allow(UploadIO).to receive(:new).and_return('FAKE FILE CONTENT')
      expect(described_class.create_from_file(@client_i3s_300, 'file.zip', 'Artifact Name').class).to eq(described_class)
    end

    it 'should use default http read_timeout when new value is not passed as parameter' do
      allow(File).to receive(:file?).and_return(true)
      allow(File).to receive(:open).with('file.zip').and_yield('FAKE FILE CONTENT')
      allow(UploadIO).to receive(:new).and_return('FAKE FILE CONTENT')
      http_fake = spy('http')
      allow(Net::HTTP).to receive(:new).and_return(http_fake)
      described_class.create_from_file(@client_i3s_300, 'file.zip', 'Artifact Name')
      expect(http_fake).to have_received(:read_timeout=).with(OneviewSDK::ImageStreamer::API300::FileUploadHelper::READ_TIMEOUT)
    end

    it 'should use value of http read_timeout passed as parameter' do
      allow(File).to receive(:file?).and_return(true)
      allow(File).to receive(:open).with('file.zip').and_yield('FAKE FILE CONTENT')
      allow(UploadIO).to receive(:new).and_return('FAKE FILE CONTENT')
      http_fake = spy('http')
      allow(Net::HTTP).to receive(:new).and_return(http_fake)
      described_class.create_from_file(@client_i3s_300, 'file.zip', 'Artifact Name', 600)
      expect(http_fake).to have_received(:read_timeout=).with(600)
    end
  end

  describe '#initialize' do
    context 'without values' do
      it 'should init with default values' do
        expect(artifact_bundle['name']).to eq(nil)
        expect(artifact_bundle['description']).to eq(nil)
        expect(artifact_bundle['buildPlans']).to eq([])
        expect(artifact_bundle['planScripts']).to eq([])
        expect(artifact_bundle['deploymentPlans']).to eq([])
        expect(artifact_bundle['goldenImages']).to eq([])
      end
    end

    context 'with values' do
      it 'should use this values' do
        params = {
          name: 'Artifact Bundle Name',
          description: 'Artifact Bundle description',
          buildPlans: [{'resourceUri' => '/rest/build_plan/1', 'readOnly' => false}],
          planScripts: [{'resourceUri' => '/rest/plan_script/1', 'readOnly' => false}],
          deploymentPlans: [{'resourceUri' => '/rest/deployment_plan/1', 'readOnly' => true}],
          goldenImages: [{'resourceUri' => '/rest/golden_image/1', 'readOnly' => true}],
        }

        resource = described_class.new(@client_i3s_300, params)

        expect(resource['name']).to eq('Artifact Bundle Name')
        expect(resource['description']).to eq('Artifact Bundle description')
        expect(resource['buildPlans']).to match_array([{'resourceUri' => '/rest/build_plan/1', 'readOnly' => false}])
        expect(resource['planScripts']).to match_array([{'resourceUri' => '/rest/plan_script/1', 'readOnly' => false}])
        expect(resource['deploymentPlans']).to match_array([{'resourceUri' => '/rest/deployment_plan/1', 'readOnly' => true}])
        expect(resource['goldenImages']).to match_array([{'resourceUri' => '/rest/golden_image/1', 'readOnly' => true}])
      end
    end
  end

  describe '#add_build_plan' do

    context 'when build plan param can be retrieved' do
      it 'should add it correctly to the build plans set' do
        resource_1 = OneviewSDK::ImageStreamer::API300::BuildPlan.new(@client_i3s_300)
        resource_2 = OneviewSDK::ImageStreamer::API300::BuildPlan.new(@client_i3s_300)

        allow_any_instance_of(OneviewSDK::ImageStreamer::API300::BuildPlan).to receive(:retrieve!).and_return(true)
        allow(resource_1).to receive(:[]).with('uri').and_return('/rest/build_plan/1')
        allow(resource_2).to receive(:[]).with('uri').and_return('/rest/build_plan/2')

        artifact_bundle.add_build_plan(resource_1)

        expect(artifact_bundle['buildPlans']).to match_array([{'resourceUri' => '/rest/build_plan/1', 'readOnly' => true}])

        artifact_bundle.add_build_plan(resource_2, false)

        expected_array = [
          {'resourceUri' => '/rest/build_plan/1', 'readOnly' => true},
          {'resourceUri' => '/rest/build_plan/2', 'readOnly' => false}
        ]
        expect(artifact_bundle['buildPlans']).to match_array(expected_array)
      end
    end

    context 'when build plan param can not be retrieved' do
      it 'should throw exception with correct message' do
        build_plan = OneviewSDK::ImageStreamer::API300::BuildPlan.new(@client_i3s_300)
        allow(build_plan).to receive(:retrieve!).and_return(false)

        expect { artifact_bundle.add_build_plan(build_plan) }.to raise_error(/The resource can not be retrieved. Ensure it have a valid URI./)
        expect(artifact_bundle['buildPlans']).to be_empty
      end
    end
  end

  describe '#add_plan_script' do

    context 'when plan script param can be retrieved' do
      it 'should add it correctly to the plan scripts set' do
        resource_1 = OneviewSDK::ImageStreamer::API300::PlanScripts.new(@client_i3s_300)
        resource_2 = OneviewSDK::ImageStreamer::API300::PlanScripts.new(@client_i3s_300)

        allow_any_instance_of(OneviewSDK::ImageStreamer::API300::PlanScripts).to receive(:retrieve!).and_return(true)
        allow(resource_1).to receive(:[]).with('uri').and_return('/rest/plan_script/1')
        allow(resource_2).to receive(:[]).with('uri').and_return('/rest/plan_script/2')

        artifact_bundle.add_plan_script(resource_1)

        expect(artifact_bundle['planScripts']).to match_array([{'resourceUri' => '/rest/plan_script/1', 'readOnly' => true}])

        artifact_bundle.add_plan_script(resource_2, false)

        expected_array = [
          {'resourceUri' => '/rest/plan_script/1', 'readOnly' => true},
          {'resourceUri' => '/rest/plan_script/2', 'readOnly' => false}
        ]
        expect(artifact_bundle['planScripts']).to match_array(expected_array)
      end
    end

    context 'when plan script param can not be retrieved' do
      it 'should throw exception with correct message' do
        plan_script = OneviewSDK::ImageStreamer::API300::PlanScripts.new(@client_i3s_300)
        allow(plan_script).to receive(:retrieve!).and_return(false)

        expect { artifact_bundle.add_plan_script(plan_script) }.to raise_error(/The resource can not be retrieved. Ensure it have a valid URI./)
        expect(artifact_bundle['planScripts']).to be_empty
      end
    end
  end

  describe '#add_deployment_plan' do

    context 'when deployment plan param can be retrieved' do
      it 'should add it correctly to the deployment plans set' do
        resource_1 = OneviewSDK::ImageStreamer::API300::DeploymentPlans.new(@client_i3s_300)
        resource_2 = OneviewSDK::ImageStreamer::API300::DeploymentPlans.new(@client_i3s_300)

        allow_any_instance_of(OneviewSDK::ImageStreamer::API300::DeploymentPlans).to receive(:retrieve!).and_return(true)
        allow(resource_1).to receive(:[]).with('uri').and_return('/rest/deployment_plan/1')
        allow(resource_2).to receive(:[]).with('uri').and_return('/rest/deployment_plan/2')

        artifact_bundle.add_deployment_plan(resource_1)

        expect(artifact_bundle['deploymentPlans']).to match_array([{'resourceUri' => '/rest/deployment_plan/1', 'readOnly' => true}])

        artifact_bundle.add_deployment_plan(resource_2, false)

        expected_array = [
          {'resourceUri' => '/rest/deployment_plan/1', 'readOnly' => true},
          {'resourceUri' => '/rest/deployment_plan/2', 'readOnly' => false}
        ]
        expect(artifact_bundle['deploymentPlans']).to match_array(expected_array)
      end
    end

    context 'when deployment plan param can not be retrieved' do
      it 'should throw exception with correct message' do
        deployment_plan = OneviewSDK::ImageStreamer::API300::DeploymentPlans.new(@client_i3s_300)
        allow(deployment_plan).to receive(:retrieve!).and_return(false)

        expect { artifact_bundle.add_deployment_plan(deployment_plan) }.to raise_error(/The resource can not be retrieved. Ensure it have a valid URI./)
      end
    end
  end

  describe '#add_golden_image' do

    context 'when golden image param can be retrieved' do
      it 'should add it correctly to the golden images set' do
        resource_1 = OneviewSDK::ImageStreamer::API300::GoldenImage.new(@client_i3s_300)
        resource_2 = OneviewSDK::ImageStreamer::API300::GoldenImage.new(@client_i3s_300)

        allow_any_instance_of(OneviewSDK::ImageStreamer::API300::GoldenImage).to receive(:retrieve!).and_return(true)
        allow(resource_1).to receive(:[]).with('uri').and_return('/rest/golden_image/1')
        allow(resource_2).to receive(:[]).with('uri').and_return('/rest/golden_image/2')

        artifact_bundle.add_golden_image(resource_1)

        expect(artifact_bundle['goldenImages']).to match_array([{'resourceUri' => '/rest/golden_image/1', 'readOnly' => true}])

        artifact_bundle.add_golden_image(resource_2, false)

        expected_array = [
          {'resourceUri' => '/rest/golden_image/1', 'readOnly' => true},
          {'resourceUri' => '/rest/golden_image/2', 'readOnly' => false}
        ]
        expect(artifact_bundle['goldenImages']).to match_array(expected_array)
      end
    end

    context 'when golden image param can not be retrieved' do
      it 'should throw exception with correct message' do
        golden_image = OneviewSDK::ImageStreamer::API300::GoldenImage.new(@client_i3s_300)
        allow(golden_image).to receive(:retrieve!).and_return(false)

        expect { artifact_bundle.add_golden_image(golden_image) }.to raise_error(/The resource can not be retrieved. Ensure it have a valid URI./)
      end
    end
  end

  describe '::backup' do
    it 'should call api correctly' do
      client = @client_i3s_300.dup
      expect(client).to receive(:rest_get).with(described_class::BACKUPS_URI)
      expect(client).to receive(:response_handler).and_return({ 'members' => {} })
      expect(described_class.backup(client).class).to eq(described_class)
    end
  end

  describe '::create_backup' do
    it 'should call api correctly' do
      client = @client_i3s_300.dup
      deployment_group = OneviewSDK::ImageStreamer::API300::DeploymentGroup.new(@client_i3s_300, uri: '/rest/deployment-groups/1')

      expect(deployment_group).to receive(:retrieve!)
      expect(client).to receive(:rest_post).with(described_class::BACKUPS_URI, { 'deploymentGroupURI' => '/rest/deployment-groups/1' })
      expect(client).to receive(:response_handler).and_return('some hash object')
      expect(described_class.create_backup(client, deployment_group)).to eq('some hash object')
    end
  end

  describe '::create_backup_from_file' do
    it 'fails if the file does not exist' do
      deployment_group = OneviewSDK::ImageStreamer::API300::DeploymentGroup.new(@client_i3s_300, uri: '/rest/deployment-groups/1')
      expect do
        described_class.create_backup_from_file(@client_i3s_300, 'file.fake', deployment_group, 'Artifact Name')
      end.to raise_error(OneviewSDK::NotFound)
    end

    it 'should call api correctly' do
      client = @client_i3s_300.dup
      deployment_group = OneviewSDK::ImageStreamer::API300::DeploymentGroup.new(@client_i3s_300, uri: '/rest/deployment-groups/1')

      allow(File).to receive(:file?).and_return(true)
      allow(File).to receive(:open).with('file.zip').and_yield('FAKE FILE CONTENT')
      allow(UploadIO).to receive(:new).and_return('FAKE FILE CONTENT')
      http_fake = spy('http')
      allow(Net::HTTP).to receive(:new).and_return(http_fake)

      expect(described_class.create_from_file(@client_i3s_300, 'file.zip', deployment_group, 'Artifact Name').class).to eq(described_class)
    end
  end
end
