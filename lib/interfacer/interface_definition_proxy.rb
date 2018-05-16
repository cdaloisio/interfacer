class InterfaceDefinitionProxy
  attr_reader(
    :defined_public_methods,
    :defined_protected_methods,
    :defined_private_methods
  )

  def initialize
    @defined_public_methods = []
    @defined_protected_methods = []
    @defined_private_methods = []
  end

  def def_public_methods(*method_names)
    method_names.each do |name|
      @defined_public_methods << [name, -> { raise NotImplementedError }]
    end
  end

  def def_protected_methods(*method_names)
    method_names.each do |name|
      @defined_protected_methods << [name, -> { raise NotImplementedError }]
    end
  end

  def def_private_methods(*method_names)
    method_names.each do |name|
      @defined_private_methods << [name, -> { raise NotImplementedError }]
    end
  end
end
