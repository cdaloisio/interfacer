module DefinitionHelpers
  def define_methods_with_visibility(visibility, methods, obj)
    methods.each do |name, definition|
      obj.send(:define_method, name, definition)
      obj.send(visibility, name)
    end
  end

  def raise_for(visibility, methods, error_class)
    raise error_class, "for #{visibility} methods #{methods}" unless methods.empty?
  end

  def missing_methods(interface_methods, implementing_methods)
    interface_methods.count.positive? ? interface_methods - implementing_methods : []
  end

  def excess_methods(interface_methods, implementing_methods)
    interface_methods.count.negative? ? adapter_public_methods - interface_public_methods : []
  end
end
