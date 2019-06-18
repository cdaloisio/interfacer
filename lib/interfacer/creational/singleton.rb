module Interfacer
  module Singleton
    extend DefinitionHelpers

    def self.build(klass_sym, &block)
      klass = Class.new

      instance_definition_proxy = ImplementationDefinitionProxy.new
      raise ArgumentError, 'Must provide a block' unless block_given?
      instance_definition_proxy.instance_eval(&block)

      define_methods_with_visibility(:public, instance_definition_proxy.defined_public_methods_and_definitions, klass)
      define_methods_with_visibility(:protected, instance_definition_proxy.defined_protected_methods_and_definitions, klass)
      define_methods_with_visibility(:private, instance_definition_proxy.defined_private_methods_and_definitions, klass)

      klass.send(:private_class_method, :new)
      klass.send(:instance_variable_set, :@instance_mutex, Mutex.new)

      init_proc = lambda do |*options|
        instance_variable_set(:@options, options)
      end

      define_methods_with_visibility(:private, [[:initialize, init_proc]], klass)

      klass.define_singleton_method(:instance) do |*options|
        return @instance if @instance

        @instance_mutex.synchronize do
          @instance ||= new(*options)
        end

        @instance
      end

      classified_name = "#{klass_sym}_singleton".to_sym.classify
      Object.const_set classified_name, klass
      Object.const_get classified_name
    end
  end
end
