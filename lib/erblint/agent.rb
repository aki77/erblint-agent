# frozen_string_literal: true

require_relative "agent/version"
require_relative "agent/linters"

module Erblint
  module Agent
    class Error < StandardError; end
  end
end
