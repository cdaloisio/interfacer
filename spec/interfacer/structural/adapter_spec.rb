module Interfacer
  RSpec.describe Adapter do
    describe '.build' do
      subject(:build) do
        described_class.build(:car, with_interface: :abstract_vehicle, for_class: :scooter) do
          start do
            "START"
          end

          stop do
            "STOP"
          end

          protected

          reset do
            "RESET"
          end
        end
      end

      it 'works', :aggregate_failures do
        Interface.build(:abstract_vehicle) do
          def_public_methods(:start, :stop)
          def_protected_methods(:reset)
        end
        expect(build).to eq ScooterToCarAdapter
      end
    end
  end
end
