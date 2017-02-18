require 'spec_helper'

describe Fastlane::Actions::SetValueInBuildAction do
  describe "Set buildToolsVersion" do
    before do
      copy_build_fixture
    end

    def execute_lane_test
      Fastlane::FastFile.new.parse("lane :test do
        set_value_in_build(
          key: \"buildToolsVersion\",
          value: \"24.1.0\"
        )
      end").runner.execute(:test)
    end

    def build_tools_version
      Fastlane::FastFile.new.parse("lane :test do
        get_value_from_build(
          key: \"buildToolsVersion\"
        )
      end").runner.execute(:test)
    end

    it "should return incremented version code from default build.gradle" do
      execute_lane_test
      expect(build_tools_version).to eq("24.1.0")
    end

    after do
      remove_fixture
    end
  end
end
