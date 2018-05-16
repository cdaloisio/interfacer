module Interfacer
  module Interface
    def self.build(module_sym, &block)
      modjule = Module.new

      definition_proxy = InterfaceDefinitionProxy.new
      definition_proxy.instance_eval(&block)

      define_methods_with_visibility(:public, definition_proxy.defined_public_methods, modjule)
      define_methods_with_visibility(:protected, definition_proxy.defined_protected_methods, modjule)
      define_methods_with_visibility(:private, definition_proxy.defined_private_methods, modjule)

      modularized_name = module_sym.classify
      Object.const_set modularized_name, modjule
      Object.const_get modularized_name
    end

    private_class_method def self.define_methods_with_visibility(visibility, methods, modjule)
      methods.each do |name, definition|
        modjule.send(:define_method, name, definition)
        modjule.send(visibility, name)
      end
    end
  end
end
