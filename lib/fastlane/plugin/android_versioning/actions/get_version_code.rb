require 'fileutils'

module Fastlane
  module Actions
    module SharedValues
      VERSION_CODE = :VERSION_CODE
    end
    class GetVersionCodeAction < Action
      def self.run(params)
        code = GetValueFromBuildAction.run(
          app_folder_name: params[:app_folder_name],
          key: "versionCode"
        )
        Actions.lane_context[SharedValues::VERSION_CODE] = code
        code
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
                               default_value: "app")
        ]
      end

      def self.description
        "Get the version code of your project"
      end

      def self.details
        [
          "This action will return the current version code set on your project's build.gradle."
        ].join(' ')
      end

      def self.output
        [
          ['VERSION_CODE', 'The version code']
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
