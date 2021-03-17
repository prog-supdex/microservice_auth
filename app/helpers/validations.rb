class Roda
  module RodaPlugins
    module Validations
      class InvalidParams < StandardError; end

      module RequestMethods
        def validate_with!(validation:, params:)
          result = validate_with(validation: validation, params: params)

          raise InvalidParams if result.failure?

          result
        end

        def validate_with(validation:, params:)
          contract = validation.new
          result = contract.call(params)

          result
        end
      end
    end

    register_plugin :validations, Validations
  end
end
