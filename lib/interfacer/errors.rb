module Interfacer
  class Error < StandardError; end

  class MissingInterface < Error; end
  class MissingMethodsDetected < Error; end
  class AdditionalMethodsDetected < Error; end
  class IncompatibleImplementation < Error; end
end
