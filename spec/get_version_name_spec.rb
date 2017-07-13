require 'spec_helper'

describe Fastlane::Actions::GetVersionNameAction do
  describe "Get Version Name" do
    def execute_lane_test
      Fastlane::FastFile.new.parse("lane :test do
        get_version_name
      end").runner.execute(:test)
    end

    it "should return version name from default build.gradle" do
      expect(execute_lane_test).to eq("1.0.0")
    end

    it "should return verson name from sample/build.gradle" do
      result = Fastlane::FastFile.new.parse("lane :test do
        get_version_name(
          app_project_dir: \"sample\"
        )
      end").runner.execute(:test)
      expect(result).to eq("2.0.0")
    end
  end
end
