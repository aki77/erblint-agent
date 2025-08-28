# frozen_string_literal: true

require "erb_lint"
require "erb_lint/linter"
require "erb_lint/linter_registry"
require "erb_lint/linter_config"
require_relative "../custom_helpers"

module ERBLint
  module Linters
    module Agent
      # This class is a custom ERBLint linter that prohibits direct usage of emojis in ERB templates.
      # Instead of writing emojis directly, it encourages the use of appropriate helpers or components.
      # It detects violations and reports them as offenses within ERBLint.
      class NoDirectEmoji < ERBLint::Linter
        include ERBLint::Linters::Agent::CustomHelpers
        include ERBLint::LinterRegistry

        # Configuration schema for NoDirectEmoji linter
        class ConfigSchema < ERBLint::LinterConfig
          property :message, accepts: String, default: nil
        end

        self.config_schema = ConfigSchema

        MESSAGE = "Direct emoji usage is prohibited. " \
                  "Use Tailwind CSS Icons (i-bi-* classes) instead. " \
                  "Example: <span class=\"i-bi-emoji-smile\"></span>"

        EMOJI_REGEX = /[\u{1F300}-\u{1F9FF}]| # Miscellaneous emojis
                      [\u{2600}-\u{26FF}]|   # Various symbols
                      [\u{2700}-\u{27BF}]|   # Dingbats
                      [\u{1F000}-\u{1F02F}]| # Mahjong tiles
                      [\u{1FA70}-\u{1FAFF}]| # Extended emojis
                      [\u{2300}-\u{23FF}]/x # Technical symbols

        def run(processed_source)
          file_content = processed_source.file_content

          scan_emoji_pattern(processed_source, file_content)
        end

        private

        def scan_emoji_pattern(processed_source, file_content)
          file_content.scan(EMOJI_REGEX) do |_match|
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
