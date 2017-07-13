require 'spec_helper'

describe Fastlane::Actions::GetVersionNameAction do
  describe "Get Version Name" do
    def execute_lane_test
      Fastlane::FastFile.new.parse("lane :test do
        get_version_name(
          app_project_dir: \"**/app\"
        )
      end").runner.execute(:test)
    end

    it "should return version name from build.gradle" do
      expect(execute_lane_test).to eq("1.0.0")
    end
  end
end
