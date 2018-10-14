require 'spec_helper'

describe Fastlane::Actions::SetValueInBuildAction do
  describe "Set buildToolsVersion" do
    before do
      copy_build_fixture
    end

    def execute_lane_test
      Fastlane::FastFile.new.parse("lane :test do
        set_value_in_build(
          app_project_dir: \"../**/app\",
          key: \"buildToolsVersion\",
          value: \"24.1.0\"
        )
      end").runner.execute(:test)
    end

    def build_tools_version
      Fastlane::FastFile.new.parse("lane :test do
        get_value_from_build(
          app_project_dir: \"../**/app\",
          key: \"buildToolsVersion\"
        )
      end").runner.execute(:test)
    end

    it "should return incremented version code from build.gradle" do
      execute_lane_test
      expect(build_tools_version).to eq("24.1.0")
    end

    after do
      remove_fixture
    end
  end

  describe "Set a non string value" do
    before do
      copy_build_fixture
    end

    def execute_lane_test
      Fastlane::FastFile.new.parse("lane :test do
        set_value_in_build(
          app_project_dir: \"../**/app\",
          key: \"versionCode\",
          value: \"123\"
        )
      end").runner.execute(:test)
    end

    def version_code
      Fastlane::FastFile.new.parse("lane :test do
        get_value_from_build(
          app_project_dir: \"../**/app\",
          key: \"versionCode\"
        )
      end").runner.execute(:test)
    end

    it "should return incremented version code from build.gradle" do
      execute_lane_test
      expect(version_code).to eq("123")
    end

    after do
      remove_fixture
    end
  end

  describe "Set an empty string" do
    before do
      copy_build_fixture
    end

    def execute_lane_test
      Fastlane::FastFile.new.parse("lane :test do
        set_value_in_build(
          app_project_dir: \"../**/app\",
          key: \"applicationIdSuffix\",
          value: \".beta\"
        )
      end").runner.execute(:test)
    end

    def application_id_suffix
      Fastlane::FastFile.new.parse("lane :test do
        get_value_from_build(
          app_project_dir: \"../**/app\",
          key: \"applicationIdSuffix\"
        )
      end").runner.execute(:test)
    end

    it "should return updated suffix from build.gradle" do
      execute_lane_test
      expect(application_id_suffix).to eq(".beta")
    end

    after do
      remove_fixture
    end
  end
end
