class Roda
  module RodaPlugins
    module ApiErrors
      module InstanceMethods
        Roda.plugin(:error_handler) do |e|
          case e
          when Sequel::NoMatchingRow
            response.status = :not_found

            error_response I18n.t(:not_found, scope: 'api.errors')
          when Sequel::UniqueConstraintViolation
            respose.status = :not_unique

            error_response I18n.t(:not_unique, scope: 'api.errors')
          when Sequel::NotNullConstraintViolation, Roda::RodaPlugins::Validations::InvalidParams, KeyError
            response.status = 422

            error_response I18n.t(:missing_parameters, scope: 'api.errors')
          end
        end

        private

        def error_response(error_messages)
          case error_messages
          when Sequel::Model
            ErrorSerializer.from_model(error_messages)
          else
            ErrorSerializer.from_messages(error_messages)
          end
        end
      end
    end

    register_plugin :api_errors, ApiErrors
  end
end

