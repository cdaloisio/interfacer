RSpec.describe Interfacer::Interface do
  describe '.build' do
    subject(:build) do
      described_class.build(:vehicle) do
        def_public_methods(:example_string, :example_integer)
        def_protected_methods(:example_protected)
        def_private_methods(:example_private)
      end
    end

    it 'works', :aggregate_failures do
      expect(build).to eq VehicleInterface
      expect(build.public_instance_methods).to include(:example_string, :example_integer)
      expect(build.private_instance_methods).to include(:example_private)
      expect(build.protected_instance_methods).to include(:example_protected)
      expect { Class.new.extend(build).example_string }.to raise_error(NotImplementedError)
      expect { Class.new.extend(build).example_integer }.to raise_error(NotImplementedError)
      expect { Class.new.extend(build).send(:example_protected) }.to raise_error(NotImplementedError)
      expect { Class.new.extend(build).send(:example_private) }.to raise_error(NotImplementedError)
    end
  end
end
