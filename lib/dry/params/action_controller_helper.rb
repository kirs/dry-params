module Dry
  class Params
    module ActionControllerHelper
      def dry_params
        Dry::Params.new(request.parameters)
      end
    end
  end
end
