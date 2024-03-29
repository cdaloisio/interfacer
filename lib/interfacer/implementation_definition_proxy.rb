class ImplementationDefinitionProxy
  def initialize
    @defined_public_methods = []
    @defined_protected_methods = []
    @defined_private_methods = []
    @visibility = :public
  end

  def defined_public_methods_and_definitions
    @defined_public_methods
  end

  def defined_protected_methods_and_definitions
    @defined_protected_methods
  end

  def defined_private_methods_and_definitions
    @defined_private_methods
  end

  def defined_public_methods
    @defined_public_methods.map(&:first).sort
  end

  def defined_protected_methods
    @defined_protected_methods.map(&:first).sort
  end

  def defined_private_methods
    @defined_private_methods.map(&:first).sort
  end

  def method_missing(name, *args, &block)
    return if set_visibility(name)
    case @visibility
    when :public
      @defined_public_methods << [name, block]
    when :protected
      @defined_protected_methods << [name, block]
    when :private
      @defined_private_methods << [name, block]
    else
      raise NotImplementedError, "Unknown visibility #{@visibility} - must be :public, :protected, :private"
    end
  end

  def init(*arg_names)
    init_proc = lambda do |*arg_values|
      arg_names.zip(arg_values).each do |name, value|
        instance_variable_set("@#{name}", value)
      end
    end
    @defined_public_methods << [:initialize, init_proc]
  end

  private

  def set_visibility(name)
    case name
    when :protected, :private
      @visibility = name
      return true
    else
      false
    end
  end
end
