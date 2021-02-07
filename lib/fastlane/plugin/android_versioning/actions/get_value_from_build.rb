require 'fileutils'

module Fastlane
  module Actions
    class GetValueFromBuildAction < Action
      def self.run(params)
        app_project_dir ||= params[:app_project_dir]
        regex = Regexp.new(/(?<key>#{params[:key]}\s+)(?<left>[\'\"]?)(?<value>[a-zA-Z0-9\.\_]*)(?<right>[\'\"]?)(?<comment>.*)/)
        flavor = params[:flavor]
        flavorSpecified = !(flavor.nil? or flavor.empty?)
        regex_flavor = Regexp.new(/[ \t]#{flavor}[ \t]/)
        value = ""
        found = false
        flavorFound = false
        productFlavorsSection = false
        Dir.glob("#{app_project_dir}/build.gradle") do |path|
          UI.verbose("path: #{path}")
          UI.verbose("absolute_path: #{File.expand_path(path)}")
          begin
            File.open(path, 'r') do |file|
              file.each_line do |line|

                if flavorSpecified and !productFlavorsSection
                  unless line.include? "productFlavors"
                    next
                  end
                  productFlavorsSection = true
                end

                if flavorSpecified and !flavorFound
                  unless line.match(regex_flavor)
                    next
                  end
                  flavorFound = true
                end

                unless line.match(regex) and !found
                  next
                end
                key, left, value, right, comment = line.match(regex).captures
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
          FastlaneCore::ConfigItem.new(key: :app_project_dir,
                                  env_name: "ANDROID_VERSIONING_APP_PROJECT_DIR",
                               description: "The path to the application source folder in the Android project (default: android/app)",
                                  optional: true,
                                      type: String,
                             default_value: "android/app"),
          FastlaneCore::ConfigItem.new(key: :flavor,
                                    env_name: "ANDROID_VERSIONING_FLAVOR",
                                 description: "The product flavor name (optional)",
                                    optional: true,
                                        type: String),
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
