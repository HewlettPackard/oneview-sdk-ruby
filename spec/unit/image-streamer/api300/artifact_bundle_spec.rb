require 'spec_helper'

RSpec.describe OneviewSDK::ImageStreamer::API300::ArtifactBundle do
  include_context 'shared context'

  subject(:artifact_bundle) { described_class.new(@client_i3s_300, uri: '/rest/artifact-bundles/UUID-111') }

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

  describe '::ACCEPTED_FORMATS' do
    it { expect(described_class::ACCEPTED_FORMATS).to eq(['.zip', '.ZIP']) }
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
          buildPlans: [{ 'resourceUri' => '/rest/build_plan/1', 'readOnly' => false }],
          planScripts: [{ 'resourceUri' => '/rest/plan_script/1', 'readOnly' => false }],
          deploymentPlans: [{ 'resourceUri' => '/rest/deployment_plan/1', 'readOnly' => true }],
          goldenImages: [{ 'resourceUri' => '/rest/golden_image/1', 'readOnly' => true }]
        }

        resource = described_class.new(@client_i3s_300, params)

        expect(resource['name']).to eq('Artifact Bundle Name')
        expect(resource['description']).to eq('Artifact Bundle description')
        expect(resource['buildPlans']).to match_array([{ 'resourceUri' => '/rest/build_plan/1', 'readOnly' => false }])
        expect(resource['planScripts']).to match_array([{ 'resourceUri' => '/rest/plan_script/1', 'readOnly' => false }])
        expect(resource['deploymentPlans']).to match_array([{ 'resourceUri' => '/rest/deployment_plan/1', 'readOnly' => true }])
        expect(resource['goldenImages']).to match_array([{ 'resourceUri' => '/rest/golden_image/1', 'readOnly' => true }])
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

        expect(artifact_bundle['buildPlans']).to match_array([{ 'resourceUri' => '/rest/build_plan/1', 'readOnly' => true }])

        artifact_bundle.add_build_plan(resource_2, false)

        expected_array = [
          { 'resourceUri' => '/rest/build_plan/1', 'readOnly' => true },
          { 'resourceUri' => '/rest/build_plan/2', 'readOnly' => false }
        ]
        expect(artifact_bundle['buildPlans']).to match_array(expected_array)
      end
    end

    context 'when build plan param can not be retrieved' do
      it 'should throw exception with correct message' do
        build_plan = OneviewSDK::ImageStreamer::API300::BuildPlan.new(@client_i3s_300)
        allow(build_plan).to receive(:retrieve!).and_return(false)

        expected_message = /The resource OneviewSDK::ImageStreamer::API300::BuildPlan can not be retrieved. Ensure it can be retrieved./
        expect { artifact_bundle.add_build_plan(build_plan) }.to raise_error(expected_message)
        expect(artifact_bundle['buildPlans']).to be_empty
      end
    end
  end

  describe '#add_plan_script' do

    context 'when plan script param can be retrieved' do
      it 'should add it correctly to the plan scripts set' do
        resource_1 = OneviewSDK::ImageStreamer::API300::PlanScript.new(@client_i3s_300)
        resource_2 = OneviewSDK::ImageStreamer::API300::PlanScript.new(@client_i3s_300)

        allow_any_instance_of(OneviewSDK::ImageStreamer::API300::PlanScript).to receive(:retrieve!).and_return(true)
        allow(resource_1).to receive(:[]).with('uri').and_return('/rest/plan_script/1')
        allow(resource_2).to receive(:[]).with('uri').and_return('/rest/plan_script/2')

        artifact_bundle.add_plan_script(resource_1)

        expect(artifact_bundle['planScripts']).to match_array([{ 'resourceUri' => '/rest/plan_script/1', 'readOnly' => true }])

        artifact_bundle.add_plan_script(resource_2, false)

        expected_array = [
          { 'resourceUri' => '/rest/plan_script/1', 'readOnly' => true },
          { 'resourceUri' => '/rest/plan_script/2', 'readOnly' => false }
        ]
        expect(artifact_bundle['planScripts']).to match_array(expected_array)
      end
    end

    context 'when plan script param can not be retrieved' do
      it 'should throw exception with correct message' do
        plan_script = OneviewSDK::ImageStreamer::API300::PlanScript.new(@client_i3s_300)
        allow(plan_script).to receive(:retrieve!).and_return(false)

        expected_message = /The resource OneviewSDK::ImageStreamer::API300::PlanScript can not be retrieved. Ensure it can be retrieved./
        expect { artifact_bundle.add_plan_script(plan_script) }.to raise_error(expected_message)
        expect(artifact_bundle['planScripts']).to be_empty
      end
    end
  end

  describe '#add_deployment_plan' do

    context 'when deployment plan param can be retrieved' do
      it 'should add it correctly to the deployment plans set' do
        resource_1 = OneviewSDK::ImageStreamer::API300::DeploymentPlan.new(@client_i3s_300)
        resource_2 = OneviewSDK::ImageStreamer::API300::DeploymentPlan.new(@client_i3s_300)

        allow_any_instance_of(OneviewSDK::ImageStreamer::API300::DeploymentPlan).to receive(:retrieve!).and_return(true)
        allow(resource_1).to receive(:[]).with('uri').and_return('/rest/deployment_plan/1')
        allow(resource_2).to receive(:[]).with('uri').and_return('/rest/deployment_plan/2')

        artifact_bundle.add_deployment_plan(resource_1)

        expect(artifact_bundle['deploymentPlans']).to match_array([{ 'resourceUri' => '/rest/deployment_plan/1', 'readOnly' => true }])

        artifact_bundle.add_deployment_plan(resource_2, false)

        expected_array = [
          { 'resourceUri' => '/rest/deployment_plan/1', 'readOnly' => true },
          { 'resourceUri' => '/rest/deployment_plan/2', 'readOnly' => false }
        ]
        expect(artifact_bundle['deploymentPlans']).to match_array(expected_array)
      end
    end

    context 'when deployment plan param can not be retrieved' do
      it 'should throw exception with correct message' do
        deployment_plan = OneviewSDK::ImageStreamer::API300::DeploymentPlan.new(@client_i3s_300)
        allow(deployment_plan).to receive(:retrieve!).and_return(false)

        expected_message = /The resource OneviewSDK::ImageStreamer::API300::DeploymentPlan can not be retrieved. Ensure it can be retrieved./
        expect do
          artifact_bundle.add_deployment_plan(deployment_plan)
        end.to raise_error(expected_message)
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

        expect(artifact_bundle['goldenImages']).to match_array([{ 'resourceUri' => '/rest/golden_image/1', 'readOnly' => true }])

        artifact_bundle.add_golden_image(resource_2, false)

        expected_array = [
          { 'resourceUri' => '/rest/golden_image/1', 'readOnly' => true },
          { 'resourceUri' => '/rest/golden_image/2', 'readOnly' => false }
        ]
        expect(artifact_bundle['goldenImages']).to match_array(expected_array)
      end
    end

    context 'when golden image param can not be retrieved' do
      it 'should throw exception with correct message' do
        golden_image = OneviewSDK::ImageStreamer::API300::GoldenImage.new(@client_i3s_300)
        allow(golden_image).to receive(:retrieve!).and_return(false)

        expected_message = /The resource OneviewSDK::ImageStreamer::API300::GoldenImage can not be retrieved. Ensure it can be retrieved./
        expect { artifact_bundle.add_golden_image(golden_image) }.to raise_error(expected_message)
      end
    end
  end

  describe '::create_from_file' do
    it 'should call a upload_file from FileUploadHelper' do
      fake_response = { 'name' => 'Artifact Name' }

      expect(@client_i3s_300).to receive(:upload_file).with('file.zip', '/rest/artifact-bundles', { 'name' => 'Artifact_Name.zip' }, 500)
        .and_return(fake_response)

      result = described_class.create_from_file(@client_i3s_300, 'file.zip', 'Artifact_Name', 500)

      expect(result.class).to eq(described_class)
      expect(result['name']).to eq('Artifact Name')
    end

    context 'when upload a file with wrong extension' do
      it 'should throw invalid format error' do
        expected_message = 'File extension should be [".zip", ".ZIP"]'
        expect do
          described_class.create_from_file(@client_i3s_300, 'file', 'Artifact Name', 500)
        end.to raise_error(OneviewSDK::InvalidFormat, expected_message)
      end
    end
  end

  describe '::get_backups' do
    it 'should call get backups correctly' do
      fake_http_response = spy('http_response')
      fake_response = { 'members' => [{ 'name' => 'Backup Name', 'test' => 'Test attr' }] }
      expect(@client_i3s_300).to receive(:rest_get).with('/rest/artifact-bundles/backups').and_return(fake_http_response)
      expect(@client_i3s_300).to receive(:response_handler).with(fake_http_response).and_return(fake_response)

      result = described_class.get_backups(@client_i3s_300)

      expect(result.class).to eq(Array)
      expect(result.first.class).to eq(described_class)
      expect(result.first['name']).to eq('Backup Name')
      expect(result.first['test']).to eq('Test attr')
    end
  end

  describe '::create_backup' do
    it 'should call api correctly' do
      client = @client_i3s_300.dup
      deployment_group = OneviewSDK::ImageStreamer::API300::DeploymentGroup.new(@client_i3s_300, uri: '/rest/deployment-groups/1')

      expect(deployment_group).to receive(:retrieve!).and_return(true)
      expect(client).to receive(:rest_post).with(described_class::BACKUPS_URI, 'body' => { 'deploymentGroupURI' => '/rest/deployment-groups/1' })
      expect(client).to receive(:response_handler).and_return('some hash object')
      expect(described_class.create_backup(client, deployment_group)).to eq('some hash object')
    end
  end

  describe '::create_backup_from_file!' do
    let(:deployment_group) { OneviewSDK::ImageStreamer::API300::DeploymentGroup.new(@client_i3s_300, uri: '/rest/deployment-groups/1') }
    before { expect(deployment_group).to receive(:retrieve!).and_return(true) }

    it 'should call @client.upload_file' do
      params = { 'name' => 'Artifact_Name.zip', 'deploymentGrpUri' => '/rest/deployment-groups/1' }
      expect(@client_i3s_300).to receive(:upload_file).with('file.zip', '/rest/artifact-bundles/backups/archive', params, 300)

      described_class.create_backup_from_file!(@client_i3s_300, deployment_group, 'file.zip', 'Artifact_Name')
    end

    context 'when upload a file with wrong extension' do
      it 'should throw invalid format error' do
        expected_message = 'File extension should be [".zip", ".ZIP"]'
        expect do
          described_class.create_backup_from_file!(@client_i3s_300, deployment_group, 'file', 'Name')
        end.to raise_error(OneviewSDK::InvalidFormat, expected_message)
      end
    end
  end

  describe '::download_backup' do
    it 'should call @client.download_file' do
      options = { 'downloadURI' => '/rest/artifact-bundles/backups/archive/UUID-1' }
      artifact_backup = OneviewSDK::ImageStreamer::API300::ArtifactBundle.new(@client_i3s_300, options)

      expect(@client_i3s_300).to receive(:download_file).with('/rest/artifact-bundles/backups/archive/UUID-1', 'path_to/file.zip')

      described_class.download_backup(@client_i3s_300, 'path_to/file.zip', artifact_backup)
    end
  end

  describe '::extract_backup' do
    it 'should call rest api correctly' do
      deployment_group = OneviewSDK::ImageStreamer::API300::DeploymentGroup.new(@client_i3s_300, uri: '/rest/deployment-groups/1')
      artifact_backup = OneviewSDK::ImageStreamer::API300::ArtifactBundle.new(@client_i3s_300, uri: '/rest/artifact-bundles/UUID-1')
      expected_params = { 'body' => { 'deploymentGroupURI' => '/rest/deployment-groups/1' } }
      fake_response = spy('http_response')
      expect(deployment_group).to receive(:retrieve!).and_return(true)
      expect(@client_i3s_300).to receive(:rest_put).with('/rest/artifact-bundles/backups/UUID-1', expected_params).and_return(fake_response)
      expect(@client_i3s_300).to receive(:response_handler).with(fake_response)

      result = described_class.extract_backup(@client_i3s_300, deployment_group, artifact_backup)

      expect(result).to eq(true)
    end

    context 'when bundle backup has not uri' do
      it 'should throw IncompleteResource error' do
        deployment_group = OneviewSDK::ImageStreamer::API300::DeploymentGroup.new(@client_i3s_300, uri: '/rest/deployment-groups/1')
        allow(deployment_group).to receive(:retrieve!).and_return(true)
        artifact_backup = OneviewSDK::ImageStreamer::API300::ArtifactBundle.new(@client_i3s_300)

        expect do
          described_class.extract_backup(@client_i3s_300, deployment_group, artifact_backup)
        end.to raise_error(OneviewSDK::IncompleteResource, /Missing required attribute 'uri' of backup bundle/)
      end
    end

    context 'when deployment group can not be retrieved' do
      it 'should throw IncompleteResource error' do
        deployment_group = OneviewSDK::ImageStreamer::API300::DeploymentGroup.new(@client_i3s_300)
        allow(deployment_group).to receive(:retrieve!).and_return(false)
        artifact_backup = OneviewSDK::ImageStreamer::API300::ArtifactBundle.new(@client_i3s_300, uri: '/rest/artifact-bundles/UUID-1')

        expect do
          described_class.extract_backup(@client_i3s_300, deployment_group, artifact_backup)
        end.to raise_error(
          OneviewSDK::IncompleteResource,
          /The resource OneviewSDK::ImageStreamer::API300::DeploymentGroup can not be retrieved. Ensure it can be retrieved./
        )
      end
    end
  end

  describe '#update' do
    it 'should throw unavailable method error' do
      expect { artifact_bundle.update }.to raise_error(OneviewSDK::MethodUnavailable)
    end
  end

  describe '#update_name' do
    it 'should call rest api correctly' do
      fake_response = spy('http_response')
      params = { 'body' => { 'name' => 'New Name', 'type' => 'ArtifactsBundle' } }
      expect(@client_i3s_300).to receive(:rest_put).with('/rest/artifact-bundles/UUID-111', params).and_return(fake_response)
      expect(@client_i3s_300).to receive(:response_handler).with(fake_response)

      result = artifact_bundle.update_name('New Name')

      expect(result).to eq(true)
      expect(artifact_bundle['name']).to eq('New Name')
    end

    context 'when uri is not set' do
      it 'should throw IncompleteResource error' do
        item = described_class.new(@client_i3s_300, {})
        expect { item.update_name('New Name') }.to raise_error(OneviewSDK::IncompleteResource)
      end
    end
  end

  describe '#extract' do
    context 'when extract is called with force true' do
      it 'should call rest api correctly' do
        expected_uri = '/rest/artifact-bundles/UUID-111?extract=true&forceImport=true' # forceImport is true
        expect(@client_i3s_300).to receive(:rest_put).with(expected_uri, 'Content-Type' => 'text/plain')
        expect(@client_i3s_300).to receive(:response_handler).and_return(FakeResponse.new)
        expect(artifact_bundle.extract).to eq(true)
      end
    end

    context 'when extract is called with force false' do
      it 'should call rest api correctly' do
        expected_uri = '/rest/artifact-bundles/UUID-111?extract=true&forceImport=false' # forceImport is false
        expect(@client_i3s_300).to receive(:rest_put).with(expected_uri, 'Content-Type' => 'text/plain')
        expect(@client_i3s_300).to receive(:response_handler).and_return(FakeResponse.new)
        expect(artifact_bundle.extract(false)).to eq(true)
      end
    end

    context 'when uri is not set' do
      it 'should throw IncompleteResource error' do
        item = described_class.new(@client_i3s_300, {})
        expect { item.extract }.to raise_error(OneviewSDK::IncompleteResource)
      end
    end
  end

  describe '#download' do
    it 'should call @client.download_file' do
      options = { 'downloadURI' => '/rest/artifact-bundles/backups/archive/UUID-1' }
      artifact_backup = OneviewSDK::ImageStreamer::API300::ArtifactBundle.new(@client_i3s_300, options)
      expect(@client_i3s_300).to receive(:download_file).with(options['downloadURI'], 'path_to/file.zip').and_return(true)
      result = artifact_backup.download('path_to/file.zip')
      expect(result).to eq(true)
    end

    context 'when downloadURI is not set' do
      it 'should throw IncompleteResource error' do
        expect { artifact_bundle.download('path_to/file.zip') }.to raise_error(OneviewSDK::IncompleteResource)
      end
    end
  end
end
