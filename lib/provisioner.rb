# frozen_string_literal: true
require 'pry'

VALID_ARGS = %w[complete].freeze

class Provisioner
  def initialize(args)
    validate_env
  end

  def validate_args(args)

  end

  def validate_env
    raise 'AWS_PROFILE required' unless ENV.keys.include?('AWS_PROFILE')
  end
end
