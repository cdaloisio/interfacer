require "interfacer/version"
require "helpers/symbol_helpers"


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

module Interfacer
  def self.build(class_sym, &block)
    modjule = Module.new

    definition_proxy = InterfaceDefinitionProxy.new
    definition_proxy.instance_eval(&block)

    definition_proxy.defined_public_methods.each do |name, definition|
      modjule.send(:define_method, name, definition)
    end

    definition_proxy.defined_private_methods.each do |name, definition|
      modjule.send(:private, name, definition)
    end

    classified_name = class_sym.classify
    Object.const_set classified_name, modjule
    Object.const_get classified_name
  end
end
