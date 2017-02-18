require 'spec_helper'

describe Fastlane::Actions::GetVersionCodeAction do
  describe "Get Version Code" do
    def execute_lane_test
      Fastlane::FastFile.new.parse("lane :test do
        get_version_code
      end").runner.execute(:test)
    end

    it "should return version code from default build.gradle" do
      expect(execute_lane_test).to eq("12345")
    end

    it "should return verson code from sample/build.gradle" do
      result = Fastlane::FastFile.new.parse("lane :test do
        get_version_code(
          app_folder_name: \"sample\"
        )
      end").runner.execute(:test)
      expect(result).to eq("67890")
    end
  end
end
