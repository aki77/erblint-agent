# frozen_string_literal: true

require "spec_helper"

RSpec.describe ERBLint::Linters::Agent::NoSpecificAttributes do
  let(:linter) { described_class.new(file_loader, linter_config) }
  let(:file_loader) { ERBLint::FileLoader.new(".") }
  let(:processed_source) { ERBLint::ProcessedSource.new("test.html.erb", file_content) }
  let(:linter_config) do
    described_class::ConfigSchema.new(
      forbidden_attributes: forbidden_attributes
    )
  end

  describe "#run" do
    subject { linter.run(processed_source) }

    context "with forbidden attributes configured" do
      let(:forbidden_attributes) do
        {
          "data-testid" => "Use 'data-test-selector' attribute instead",
          "onclick" => "Use event listeners instead"
        }
      end

      context "when forbidden attribute is present" do
        let(:file_content) { '<button data-testid="submit-btn">Submit</button>' }

        it "adds an offense with custom message" do
          subject
          expect(linter.offenses).not_to be_empty
          expect(linter.offenses.first.message).to include("Attribute 'data-testid' is prohibited")
          expect(linter.offenses.first.message).to include("Use 'data-test-selector' attribute instead")
        end
      end

      context "with multiple forbidden attributes" do
        let(:file_content) { '<div onclick="alert()" data-testid="test">Content</div>' }

        it "detects all forbidden attributes" do
          subject
          expect(linter.offenses.size).to eq(2)
        end
      end

      context "with allowed attributes" do
        let(:file_content) { '<button data-test-selector="submit-btn">Submit</button>' }

        it "does not add any offense" do
          subject
          expect(linter.offenses).to be_empty
        end
      end

      context "with hyphenated attributes" do
        let(:file_content) { '<div data-testid="test">Content</div>' }

        it "detects hyphenated forbidden attributes" do
          subject
          expect(linter.offenses).not_to be_empty
          expect(linter.offenses.first.message).to include("data-testid")
        end
      end

      context "when no forbidden attributes are present" do
        let(:file_content) { '<button class="btn" id="submit">Click</button>' }

        it "does not add any offense" do
          subject
          expect(linter.offenses).to be_empty
        end
      end
    end

    context "with no forbidden attributes configured" do
      let(:forbidden_attributes) { {} }
      let(:file_content) { '<button data-testid="test">Click</button>' }

      it "does not add any offense" do
        subject
        expect(linter.offenses).to be_empty
      end
    end
  end
end