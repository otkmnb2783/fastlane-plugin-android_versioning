require 'tempfile'
require 'fileutils'

module Fastlane
  module Actions
    module SharedValues
      VERSION_CODE = :VERSION_CODE
    end
    class IncrementVersionCodeAction < Action
      def self.run(params)
        current_version_code = GetVersionCodeAction.run(params)
        new_version_code = params[:version_code].nil? ? current_version_code.to_i + 1 : params[:version_code].to_i
        SetValueInBuildAction.run(
          app_folder_name: params[:app_folder_name],
          key: "versionCode",
          value: new_version_code
        )
        Actions.lane_context[SharedValues::VERSION_CODE] = new_version_code.to_s
        new_version_code.to_s
      end

      #####################################################
      # @!group Documentation
      #####################################################
      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :app_folder_name,
                                    env_name: "ANDROID_VERSIONING_APP_FOLDER_NAME",
                                 description: "The name of the application source folder in the Android project (default: app)",
                                    optional: true,
                                        type: String,
                               default_value: "app"),
          FastlaneCore::ConfigItem.new(key: :version_code,
                                  env_name: "ANDROID_VERSIONING_VERSION_CODE",
                               description: "Change to a specific version (optional)",
                                  optional: true,
                                      type: Integer)
        ]
      end

      def self.description
        "Increment the version code of your project"
      end

      def self.details
        [
          "This action will increment the version code directly in build.gradle . "
        ].join("\n")
      end

      def self.output
        [
          ['VERSION_CODE', 'The new version code']
        ]
      end

      def self.authors
        ["Manabu OHTAKE"]
      end

      def self.is_supported?(platform)
        platform == :android
      end
    end
  end
end
