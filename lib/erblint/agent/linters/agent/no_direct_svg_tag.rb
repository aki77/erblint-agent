# frozen_string_literal: true

require "erb_lint"
require "erb_lint/linter"
require "erb_lint/linter_registry"
require "erb_lint/linter_config"
require_relative "../custom_helpers"

module ERBLint
  module Linters
    module Agent
      # Linter that prohibits direct usage of <svg> tags in ERB templates.
      class NoDirectSvgTag < ERBLint::Linter
        include ERBLint::Linters::Agent::CustomHelpers
        include ERBLint::LinterRegistry

        # Configuration schema for NoDirectSvgTag linter
        class ConfigSchema < ERBLint::LinterConfig
          property :message, accepts: String, default: nil
        end

        self.config_schema = ConfigSchema

        MESSAGE = "Direct SVG tag usage is prohibited. " \
                  "Use Tailwind CSS Icons (i-bi-* classes) instead. " \
                  "Example: <span class=\"i-bi-people\"></span>"

        SELF_CLOSING_SVG_REGEX = %r{<svg\b[^>]*/\s*>}mi
        PAIRED_SVG_REGEX = %r{<svg\b[^>]*>.*?</svg\s*>}mi

        def run(processed_source)
          file_content = processed_source.file_content

          scan_svg_pattern(processed_source, file_content, SELF_CLOSING_SVG_REGEX)
          scan_svg_pattern(processed_source, file_content, PAIRED_SVG_REGEX)
        end

        private

        def scan_svg_pattern(processed_source, file_content, regex)
          file_content.scan(regex) do |_match|
            match_data = Regexp.last_match

            add_offense(
              processed_source.to_source_range(match_data.begin(0)...match_data.end(0)),
              @config.message || MESSAGE
            )
          end
        end
      end
    end
  end
end
