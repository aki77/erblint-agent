# frozen_string_literal: true

require "spec_helper"

RSpec.describe ERBLint::Linters::Agent::NoDirectSvgTag do
  let(:linter) { described_class.new(file_loader, described_class::ConfigSchema.new) }
  let(:file_loader) { ERBLint::FileLoader.new(".") }
  let(:processed_source) { ERBLint::ProcessedSource.new("test.html.erb", file_content) }

  describe "#run" do
    subject { linter.run(processed_source) }

    context "when SVG tags are present" do
      context "with self-closing SVG tag" do
        let(:file_content) { '<svg class="icon" />' }

        it "adds an offense" do
          subject
          expect(linter.offenses).not_to be_empty
          expect(linter.offenses.first.message).to include("Direct SVG tag usage is prohibited")
        end
      end

      context "with paired SVG tags" do
        let(:file_content) { '<svg><path d="M10 10" /></svg>' }

        it "adds an offense" do
          subject
          expect(linter.offenses).not_to be_empty
          expect(linter.offenses.first.message).to include("Direct SVG tag usage is prohibited")
        end
      end

      context "with multiple SVG tags" do
        let(:file_content) { "<svg /><div></div><svg></svg>" }

        it "adds multiple offenses" do
          subject
          expect(linter.offenses.size).to eq(2)
        end
      end
    end

    context "when no SVG tags are present" do
      let(:file_content) { '<div class="icon"><span class="i-bi-people"></span></div>' }

      it "does not add any offense" do
        subject
        expect(linter.offenses).to be_empty
      end
    end
  end
end
