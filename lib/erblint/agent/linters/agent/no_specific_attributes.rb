# frozen_string_literal: true

require "erb_lint"
require "erb_lint/linter"
require "erb_lint/linter_registry"
require "erb_lint/linter_config"
require_relative "../custom_helpers"

module ERBLint
  module Linters
    module Agent
      # Linter that checks for forbidden HTML attributes in ERB templates.
      class NoSpecificAttributes < ERBLint::Linter
        include ERBLint::Linters::Agent::CustomHelpers
        include ERBLint::LinterRegistry

        class ConfigSchema < ERBLint::LinterConfig # rubocop:disable Style/Documentation
          property :forbidden_attributes, accepts: Hash, default: -> { {} }
        end

        self.config_schema = ConfigSchema

        ATTR_REGEX = /(\w+(?:-\w+)*)\s*=\s*["']/

        def run(processed_source)
          return if @config.forbidden_attributes.empty?

          file_content = processed_source.file_content

          scan_attributes(processed_source, file_content)
        end

        private

        def scan_attributes(processed_source, file_content)
          file_content.scan(ATTR_REGEX) do |attr_name|
            match_data = Regexp.last_match
            attribute_name = attr_name[0]

            next unless @config.forbidden_attributes.key?(attribute_name)

            message = @config.forbidden_attributes[attribute_name]

            add_offense(
              processed_source.to_source_range(match_data.begin(0)...match_data.end(0)),
              "Attribute '#{attribute_name}' is prohibited. #{message}"
            )
          end
        end
      end
    end
  end
end
