# frozen_string_literal: true

module ERBLint
  module Linters
    module Agent
      # Provides custom helper methods for ERB linting agents.
      module CustomHelpers
        def generate_offense(klass, processed_source, tag, message = nil, replacement = nil)
          message ||= klass::MESSAGE
          offense = ["#{simple_class_name}:#{message}", tag.node.loc.source].join("\n")
          add_offense(processed_source.to_source_range(tag.loc), offense, replacement)
        end

        def generate_offense_from_source_range(klass, source_range, message = nil, replacement = nil)
          message ||= klass::MESSAGE
          offense = ["#{simple_class_name}:#{message}", source_range.source].join("\n")
          add_offense(source_range, offense, replacement)
        end

        def tags(processed_source)
          processed_source.parser.nodes_with_type(:tag).map { |tag_node| BetterHtml::Tree::Tag.from_node(tag_node) }
        end

        def simple_class_name
          self.class.name.gsub("ERBLint::Linters::", "")
        end
      end
    end
  end
end
