require 'interfacer/implementation_definition_proxy'
require 'interfacer/interface_definition_proxy'
require 'interfacer/interface'
require 'interfacer/version'
require 'helpers/symbol_helpers'

class MissingInterface < StandardError; end
class MissingMethodsDetected < StandardError; end
class AdditionalMethodsDetected < StandardError; end

module Interfacer
  def self.implement(module_sym, for_class:, &block)
    modularized_name = module_sym.classify
    modjule = Object.const_get modularized_name

    klass = Class.new

    definition_proxy = ImplementationDefinitionProxy.new
    raise ArgumentError, 'Must provide a block' unless block_given?
    definition_proxy.instance_eval(&block)

    public_definitions_diff = modjule.instance_methods.sort - definition_proxy.defined_public_methods.map(&:first).sort - [:initialize]
    if public_definitions_diff.count.positive?
      raise MissingMethodsDetected, "Missing definitions for #{public_definitions_diff}"
    end

    public_definitions_diff = definition_proxy.defined_public_methods.map(&:first).sort - modjule.instance_methods.sort - [:initialize]
    if public_definitions_diff.count.positive?
      raise AdditionalMethodsDetected, "Additional definitions detected, please remove #{public_definitions_diff}"
    end

    definition_proxy.defined_public_methods.each do |name, definition|
      klass.send(:define_method, name, definition)
    end

    classified_name = for_class.classify
    Object.const_set classified_name, klass
    Object.const_get classified_name
  rescue NameError
    raise MissingInterface, modularized_name
  end
end
