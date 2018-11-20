module Interfacer
  RSpec.describe Adapter do
    describe '.build' do
      context 'with base example' do
        subject(:build) do
          described_class.build(:car, with_interface: :abstract_vehicle, for_class: :scooter) do
            start do
              'START'
            end

            stop do
              'STOP'
            end

            protected

            reset do
              'RESET'
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

      context 'with refactoring guru example' do
        subject(:build) do
          described_class.build(:round_peg, with_interface: :round_peg, for_class: :square_peg) do
            radius do
              @square_peg.width * Math.sqrt(2) / 2
            end
          end
        end

        before do
          class RoundHole
            def initialize(radius)
              @radius = radius
            end

            def fits(peg)
              @radius >= peg.radius
            end
          end

          class RoundPeg
            def initialize(radius)
              @radius = radius
            end

            def radius
              @radius
            end
          end

        end

        let(:square_peg) do
          class SquarePeg
            def initialize(width)
              @width = width
            end

            def width
              @width
            end
          end
          SquarePeg.new(2)
        end

        it 'works' do
          Interface.build(:round_peg) do
            def_public_methods(:radius)
          end
          expect(build).to eq SquarePegToRoundPegAdapter
          expect(build.new(square_peg).radius.round(2)).to eq 1.41
          # TODO: expect RoundHole#methods to enforce interface types
        end
      end
    end
  end
end
