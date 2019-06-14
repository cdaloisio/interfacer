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

        specify do
          Interface.build(:abstract_vehicle) do
            def_public_methods(:start, :stop)
            def_protected_methods(:reset)
          end
          expect(build).to eq ScooterToCarAdapter
        end
      end

      context 'with refactoring guru example' do
        subject(:adapter) do
          described_class.build(:round_peg, with_interface: :round_peg, for_class: :square_peg) do
            radius do
              @square_peg.width * Math.sqrt(2) / 2
            end
          end
        end

        before do
          class SquarePeg
            def initialize(width)
              @width = width
            end

            def width
              @width
            end
          end
        end

        let(:round_hole) do
          class RoundHole
            def initialize(radius)
              @radius = radius
            end

            def fits(peg)
              @radius >= peg.radius
            end
          end

          RoundHole.new(2.5)
        end

        let(:round_peg) do
          class RoundPeg
            def initialize(radius)
              @radius = radius
            end

            def radius
              @radius
            end
          end

          RoundPeg.new(2.5)
        end

        let(:small_square_peg) do
          SquarePeg.new(2)
        end

        let(:large_square_peg) do
          SquarePeg.new(5)
        end

        it 'works', aggregate_failures: true do
          Interface.build(:round_peg) do
            def_public_methods(:radius)
          end
          expect(adapter).to eq SquarePegToRoundPegAdapter
          expect(round_hole.fits(round_peg)).to eq true
          expect(round_hole.fits(adapter.new(small_square_peg))).to eq true
          expect(round_hole.fits(adapter.new(large_square_peg))).to eq false
        end
      end
    end
  end
end
