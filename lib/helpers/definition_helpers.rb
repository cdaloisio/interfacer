module DefinitionHelpers
  def define_methods_with_visibility(visibility, methods, obj)
    methods.each do |name, definition|
      obj.send(:define_method, name, definition)
      obj.send(visibility, name)
    end
  end
end
