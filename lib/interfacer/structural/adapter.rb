require 'helpers/definition_helpers'
require 'interfacer/errors'

module Interfacer
  module Adapter
    extend DefinitionHelpers

    def self.build(klass_sym, with_interface:, for_class:, &block)
      interface_identifier = "#{with_interface}_interface".to_sym.classify

      begin
        interface = Object.const_get interface_identifier
      rescue NameError
        raise MissingInterface, interface_identifier
      end

      klass = Class.new

      definition_proxy = ImplementationDefinitionProxy.new
      raise ArgumentError, 'Must provide a block' unless block_given?
      definition_proxy.instance_eval(&block)

      adapter_public_methods = definition_proxy.defined_public_methods
      adapter_protected_methods = definition_proxy.defined_protected_methods
      adapter_private_methods = definition_proxy.defined_private_methods

      interface_public_methods = interface.public_instance_methods.sort
      interface_protected_methods = interface.protected_instance_methods.sort
      interface_private_methods = interface.private_instance_methods.sort

      if interface_private_methods.count.positive?
        raise IncompatibleImplementation,
          "Adapters shouldn't implement interfaces with private methods. Refer to:\nhttps://refactoring.guru/design-patterns/adapter"
      end

      missing_public_methods = missing_methods(interface_public_methods, adapter_public_methods)
      missing_protected_methods = missing_methods(interface_protected_methods, adapter_protected_methods)
      missing_private_methods = missing_methods(interface_private_methods, adapter_private_methods)

      excess_public_methods = excess_methods(interface_public_methods, adapter_public_methods)
      excess_protected_methods = excess_methods(interface_protected_methods, adapter_protected_methods)
      excess_private_methods = excess_methods(interface_private_methods, adapter_private_methods)

      raise_for(:public, missing_public_methods, MissingMethodsDetected)
      raise_for(:protected, missing_protected_methods, MissingMethodsDetected)
      raise_for(:private, missing_private_methods, MissingMethodsDetected)

      raise_for(:public, excess_public_methods, AdditionalMethodsDetected)
      raise_for(:protected, excess_protected_methods, AdditionalMethodsDetected)
      raise_for(:private, excess_private_methods, AdditionalMethodsDetected)

      define_methods_with_visibility(:public, definition_proxy.defined_public_methods, klass)
      define_methods_with_visibility(:protected, definition_proxy.defined_protected_methods, klass)
      define_methods_with_visibility(:private, definition_proxy.defined_private_methods, klass)

      init_proc = lambda do |adaptee|
        instance_variable_set("@#{for_class}", adaptee)
      end

      define_methods_with_visibility(:private, [[:initialize, init_proc]], klass)

      classified_name = "#{for_class}_to_#{klass_sym}_adapter".to_sym.classify
      Object.const_set classified_name, klass
      Object.const_get classified_name
    end
  end
end
