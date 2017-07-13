require 'spec_helper'

describe Fastlane::Actions::IncrementVersionCodeAction do
  describe "Increment version code" do
    before do
      copy_build_fixture
    end

    def execute_lane_test
      Fastlane::FastFile.new.parse("lane :test do
        increment_version_code(
          app_project_dir: \"**/app\"
        )
      end").runner.execute(:test)
    end

    def execute_lane_option_test
      Fastlane::FastFile.new.parse("lane :test do
        increment_version_code(
          app_project_dir: \"**/app\",
          version_code: 123457
        )
      end").runner.execute(:test)
    end

    it "should return incremented version code from build.gradle" do
      expect(execute_lane_test).to eq("12346")
    end

    it "should return incremented fixmun version code from build.gradle" do
      expect(execute_lane_option_test).to eq("123457")
    end

    it "should set VERSION_CODE shared value" do
      result = execute_lane_test
      expect(Fastlane::Actions.lane_context[Fastlane::Actions::SharedValues::VERSION_CODE]).to eq("12346")
    end

    after do
      remove_fixture
    end
  end
end
