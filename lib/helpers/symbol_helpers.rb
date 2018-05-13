module SymbolHelpers
  def classify
    to_s.split('_').map(&:capitalize).join
  end
end

class Symbol
  include SymbolHelpers
end
