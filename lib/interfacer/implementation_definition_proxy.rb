class ImplementationDefinitionProxy
  attr_reader :defined_public_methods, :defined_private_methods

  def initialize
    @defined_public_methods = []
    @defined_private_methods = []
  end

  def method_missing(name, *_args, &block)
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
