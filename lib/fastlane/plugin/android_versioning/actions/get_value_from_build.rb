require 'fileutils'

module Fastlane
  module Actions
    class GetValueFromBuildAction < Action
      def self.run(params)
        app_folder_name ||= params[:app_folder_name]
        value = ""
        found = false
        Dir.glob("**/#{app_folder_name}/build.gradle") do |path|
          begin
            File.open(path, 'r') do |file|
              file.each_line do |line|
                unless line.include? "#{params[:key]} " and !found
                  next
                end
                components = line.strip.split(' ')
                value = components.last.tr("\"", "").tr("\'", "")
                break
              end
              file.close
            end
          end
        end
        return value
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
          FastlaneCore::ConfigItem.new(key: :key,
                               description: "The property key",
                                      type: String)

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
