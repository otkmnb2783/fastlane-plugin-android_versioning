require 'spec_helper'

describe Fastlane::Actions::GetValueFromBuildAction do
  describe "Get buildToolsVersion" do
    def execute_lane_test
      Fastlane::FastFile.new.parse("lane :test do
        get_value_from_build(
          key: \"buildToolsVersion\"
        )
      end").runner.execute(:test)
    end

    it "should return buildToolsVersion from default build.gradle" do
      result = execute_lane_test
      expect(result).to eq("24.0.2")
    end
  end
end
