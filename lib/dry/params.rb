require 'dry-validation'
require 'dry/validation/schema/form'
require 'dry/params/action_controller_helper'

module Dry
  class Params
    class ValidationError < StandardError
    end

    def initialize(params)
      @params = params
    end

    def fetch(key)
      self.class.new(@params.fetch(key.to_s))
    end

    def validate(schema_klass, mode: :strict)
      result = schema_klass.new.call(@params)
      if mode == :strict && result.messages.size > 0
        raise ValidationError, result
      end

      result.successes.each_with_object({}) { |result, hash|
        hash[result.name] = result.input
      }
    end
  end
end
