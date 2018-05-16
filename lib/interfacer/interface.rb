module Interfacer
  module Interface
    def self.build(module_sym, &block)
      modjule = Module.new

      definition_proxy = InterfaceDefinitionProxy.new
      definition_proxy.instance_eval(&block)

      definition_proxy.defined_public_methods.each do |name, definition|
        modjule.send(:define_method, name, definition)
      end

      definition_proxy.defined_protected_methods.each do |name, definition|
        modjule.send(:define_method, name, definition)
        modjule.send(:protected, name)
      end

      definition_proxy.defined_private_methods.each do |name, definition|
        modjule.send(:define_method, name, definition)
        modjule.send(:private, name)
      end

      modularized_name = module_sym.classify
      Object.const_set modularized_name, modjule
      Object.const_get modularized_name
    end
  end
end
