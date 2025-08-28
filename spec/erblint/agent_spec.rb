# frozen_string_literal: true

RSpec.describe Erblint::Agent do
  it "has a version number" do
    expect(Erblint::Agent::VERSION).not_to be nil
  end

  it "loads all linters" do
    expect(ERBLint::Linters::Agent::NoDirectSvgTag).to be_a(Class)
    expect(ERBLint::Linters::Agent::NoDirectEmoji).to be_a(Class)
    expect(ERBLint::Linters::Agent::NoSpecificClasses).to be_a(Class)
  end
end
