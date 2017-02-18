require 'tempfile'
require 'fileutils'

module Fastlane
  module Actions
    class SetValueInBuildAction < Action
      def self.run(params)
        app_folder_name ||= params[:app_folder_name]
        found = false
        Dir.glob("**/#{app_folder_name}/build.gradle") do |path|
          begin
            temp_file = Tempfile.new('versioning')
            File.open(path, 'r') do |file|
              file.each_line do |line|
                unless line.include? "#{params[:key]} " and !found
                  temp_file.puts line
                  next
                end
                components = line.strip.split(' ')
                value = components.last.tr("\"", "").tr("\'", "")
                line.replace line.sub(value, params[:value].to_s)
                found = true
                temp_file.puts line
              end
              file.close
            end
            temp_file.rewind
            temp_file.close
            FileUtils.mv(temp_file.path, path)
            temp_file.unlink
          end
        end
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
                                      type: String),
          FastlaneCore::ConfigItem.new(key: :value,
                               description: "The property value",
                                      type: String)
        ]
      end

      def self.description
        "Set the value of your project"
      end

      def self.details
        [
          "This action will set the value directly in build.gradle . "
        ].join("\n")
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
