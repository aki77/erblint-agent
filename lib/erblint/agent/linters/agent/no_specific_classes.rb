# frozen_string_literal: true

require "erb_lint"
require "erb_lint/linter"
require "erb_lint/linter_registry"
require "erb_lint/linter_config"
require_relative "../custom_helpers"

module ERBLint
  module Linters
    module Agent
      # Linter that checks for forbidden CSS class names in ERB templates.
      class NoSpecificClasses < ERBLint::Linter
        include ERBLint::Linters::Agent::CustomHelpers
        include ERBLint::LinterRegistry

        class ConfigSchema < ERBLint::LinterConfig # rubocop:disable Style/Documentation
          property :forbidden_classes, accepts: Hash, default: -> { {} }
        end

        self.config_schema = ConfigSchema

        CLASS_ATTR_REGEX = /class\s*=\s*["']([^"']+)["']/i
        ERB_CLASS_REGEX = /class\s*=\s*["']([^"']*<%[^>]*%>[^"']*)["']/i
        DYNAMIC_CLASS_REGEX = /class:\s*["']([^"']+)["']/

        def run(processed_source)
          return if @config.forbidden_classes.empty?

          file_content = processed_source.file_content

          scan_class_attributes(processed_source, file_content, CLASS_ATTR_REGEX)
          scan_class_attributes(processed_source, file_content, DYNAMIC_CLASS_REGEX)
          scan_erb_class_attributes(processed_source, file_content)
        end

        private

        def scan_class_attributes(processed_source, file_content, regex)
          file_content.scan(regex) do |classes|
            match_data = Regexp.last_match
            class_list = classes[0]

            next if class_list.include?("<%")

            check_forbidden_classes(processed_source, class_list, match_data)
          end
        end

        def scan_erb_class_attributes(processed_source, file_content)
          file_content.scan(ERB_CLASS_REGEX) do |classes|
            match_data = Regexp.last_match
            class_list = classes[0]

            static_parts = class_list.split(/<%[^>]*%>/)
            static_parts.each do |part|
              check_forbidden_classes(processed_source, part, match_data) unless part.strip.empty?
            end
          end
        end

        def check_forbidden_classes(processed_source, class_list, match_data) # rubocop:disable Metrics/MethodLength
          class_names = class_list.split(/\s+/)

          class_names.each do |class_name|
            class_name = class_name.strip
            next if class_name.empty?

            next unless @config.forbidden_classes.key?(class_name)

            message = @config.forbidden_classes[class_name]

            add_offense(
              processed_source.to_source_range(match_data.begin(0)...match_data.end(0)),
              "Class name '#{class_name}' is prohibited. #{message}"
            )
          end
        end
      end
    end
  end
end
