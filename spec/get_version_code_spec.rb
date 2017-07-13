require 'spec_helper'

describe Fastlane::Actions::GetVersionCodeAction do
  describe "Get Version Code" do
    def execute_lane_test
      Fastlane::FastFile.new.parse("lane :test do
        get_version_code(
          app_project_dir: \"./spec/fixtures/app\"
        )
      end").runner.execute(:test)
    end

    it "should return version code from build.gradle" do
      expect(execute_lane_test).to eq("12345")
    end
  end
end
