# frozen_string_literal: true

require "spec_helper"

RSpec.describe ERBLint::Linters::Agent::NoSpecificClasses do
  let(:linter) { described_class.new(file_loader, linter_config) }
  let(:file_loader) { ERBLint::FileLoader.new(".") }
  let(:processed_source) { ERBLint::ProcessedSource.new("test.html.erb", file_content) }
  let(:linter_config) do
    described_class::ConfigSchema.new(
      forbidden_classes: forbidden_classes
    )
  end

  describe "#run" do
    subject { linter.run(processed_source) }

    context "with forbidden classes configured" do
      let(:forbidden_classes) do
        {
          "btn-old" => "Use 'btn' class instead",
          "text-bold" => "Use 'font-bold' instead"
        }
      end

      context "when forbidden class is present" do
        let(:file_content) { '<button class="btn-old">Click</button>' }

        it "adds an offense with custom message" do
          subject
          expect(linter.offenses).not_to be_empty
          expect(linter.offenses.first.message).to include("Class name 'btn-old' is prohibited")
          expect(linter.offenses.first.message).to include("Use 'btn' class instead")
        end
      end

      context "with multiple classes including forbidden ones" do
        let(:file_content) { '<p class="text-bold primary large">Text</p>' }

        it "detects forbidden class among others" do
          subject
          expect(linter.offenses.size).to eq(1)
          expect(linter.offenses.first.message).to include("text-bold")
        end
      end

      context "with ERB expressions in class attribute" do
        let(:file_content) { '<div class="<%= foo %> btn-old <%= bar %>">Content</div>' }

        it "detects forbidden class in static parts" do
          subject
          expect(linter.offenses).not_to be_empty
          expect(linter.offenses.first.message).to include("btn-old")
        end
      end

      context "with Rails helper syntax" do
        let(:file_content) { '<%= link_to "Link", "#", class: "btn-old primary" %>' }

        it "detects forbidden class in Rails helpers" do
          subject
          expect(linter.offenses).not_to be_empty
          expect(linter.offenses.first.message).to include("btn-old")
        end
      end

      context "when no forbidden classes are present" do
        let(:file_content) { '<button class="btn primary">Click</button>' }

        it "does not add any offense" do
          subject
          expect(linter.offenses).to be_empty
        end
      end
    end

    context "with no forbidden classes configured" do
      let(:forbidden_classes) { {} }
      let(:file_content) { '<button class="any-class">Click</button>' }

      it "does not add any offense" do
        subject
        expect(linter.offenses).to be_empty
      end
    end
  end
end
