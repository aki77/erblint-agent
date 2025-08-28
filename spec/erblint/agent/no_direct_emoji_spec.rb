# frozen_string_literal: true

require "spec_helper"

RSpec.describe ERBLint::Linters::Agent::NoDirectEmoji do
  let(:linter) { described_class.new(file_loader, described_class::ConfigSchema.new) }
  let(:file_loader) { ERBLint::FileLoader.new(".") }
  let(:processed_source) { ERBLint::ProcessedSource.new("test.html.erb", file_content) }

  describe "#run" do
    subject { linter.run(processed_source) }

    context "when emoji are present" do
      context "with single emoji" do
        let(:file_content) { "<p>Welcome! 😊</p>" }

        it "adds an offense" do
          subject
          expect(linter.offenses).not_to be_empty
          expect(linter.offenses.first.message).to include("Direct emoji usage is prohibited")
        end
      end

      context "with multiple emoji" do
        let(:file_content) { "<p>Hello 👋 World 🌍!</p>" }

        it "adds multiple offenses" do
          subject
          expect(linter.offenses.size).to eq(2)
        end
      end

      context "with various emoji ranges" do
        let(:file_content) { "<p>☀️ ⭐ 🎨 🧸</p>" }

        it "detects all emoji" do
          subject
          expect(linter.offenses).not_to be_empty
        end
      end
    end

    context "when no emoji are present" do
      let(:file_content) { '<p>Welcome! <span class="i-bi-emoji-smile"></span></p>' }

      it "does not add any offense" do
        subject
        expect(linter.offenses).to be_empty
      end
    end
  end
end
