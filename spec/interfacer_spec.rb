RSpec.describe Interfacer do
  it "has a version number" do
    expect(Interfacer::VERSION).not_to be nil
  end

  describe '.build' do
    subject(:build) do
      Interfacer.build(:some_interface) do
        def_public_methods(:example_string, :example_integer)
        def_private_methods(:example_private)
      end
    end

    it 'works', :aggregate_failures do
      expect(build).to eq SomeInterface
      expect { Class.new.extend(build).example_string }.to raise_error(NotImplementedError)
      expect { Class.new.extend(build).example_integer }.to raise_error(NotImplementedError)
      expect { Class.new.extend(build).send(:example_private) }.to raise_error(NotImplementedError)
    end
  end
end
