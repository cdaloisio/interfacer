require "interfacer/version"
require "helpers/symbol_helpers"

class MissingInterface < StandardError; end
class MissingMethodsDetected < StandardError; end
class AdditionalMethodsDetected < StandardError; end

class InterfaceDefinitionProxy
  attr_reader :defined_public_methods, :defined_private_methods

  def initialize
    @defined_public_methods = []
    @defined_private_methods = []
  end

  def def_public_methods(*method_names)
    method_names.each do |name|
      @defined_public_methods << [name, -> { raise NotImplementedError }]
    end
  end

  def def_private_methods(*method_names)
    method_names.each do |name|
      @defined_public_methods << [name, -> { raise NotImplementedError }]
    end
  end
end

class ImplementationDefinitionProxy
  attr_reader :defined_public_methods, :defined_private_methods

  def initialize
    @defined_public_methods = []
    @defined_private_methods = []
  end

  def method_missing(name, *args, &block)
    @defined_public_methods << [name, block]
  end

  def init(*arg_names)
    init_proc = lambda do |*arg_values|
      arg_names.zip(arg_values).each do |name, value|
        instance_variable_set("@#{name}", value)
      end
    end
    @defined_public_methods << [:initialize, init_proc]
  end
end

module Interfacer
  def self.build(module_sym, &block)
    modjule = Module.new

    definition_proxy = InterfaceDefinitionProxy.new
    definition_proxy.instance_eval(&block)

    definition_proxy.defined_public_methods.each do |name, definition|
      modjule.send(:define_method, name, definition)
    end

    definition_proxy.defined_private_methods.each do |name, definition|
      modjule.send(:private, name, definition)
    end

    modularized_name = module_sym.classify
    Object.const_set modularized_name, modjule
    Object.const_get modularized_name
  end

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
