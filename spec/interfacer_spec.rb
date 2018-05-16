RSpec.describe Interfacer do
  it "has a version number" do
    expect(Interfacer::VERSION).not_to be nil
  end

  describe '.implement' do
    subject(:implement) do
      implementation
    end

    around do |example|
      Interfacer::Interface.build(:some_interface) do
        def_public_methods(:example_string, :example_integer)
      end
      example.run
      Object.send(:remove_const, :SomeInterface)
      Object.send(:remove_const, :SomethingElse) if Object.constants.include?(:SomethingElse)
    end

    let(:for_class) { :something_else }

    context 'when interface does not exist' do
      let(:implementation) do
        Interfacer.implement(:non_existent_interface, for_class: for_class)
      end

      specify { expect { implement }.to raise_error(MissingInterface, 'NonExistentInterface') }
    end

    context 'when interface does exist' do
      let(:implementation) do
        Interfacer.implement(:some_interface, for_class: for_class) do
          example_string do
            'foo'
          end

          example_integer do
            1
          end
        end
      end

      specify { expect { implement }.not_to raise_error }
    end

    context 'when an implementation has been written without an initializer' do
      let(:implementation) do
        Interfacer.implement(:some_interface, for_class: for_class) do
          example_string do
            'foo'
          end

          example_integer do
            1
          end
        end
      end

      it 'works', :aggregate_failures do
        expect(implement.new.example_string).to eq 'foo'
        expect(implement.new.example_integer).to eq 1
      end
    end

    context 'when an implementation has been written with an initializer' do
      let(:implementation) do
        Interfacer.implement(:some_interface, for_class: for_class) do
          init(:value1, :value2)

          example_string do
            @value1
          end

          example_integer do
            @value2
          end
        end
      end

      it 'works', :aggregate_failures do
        expect(implement.new('foo', 1).example_string).to eq 'foo'
        expect(implement.new('foo', 1).example_integer).to eq 1
      end
    end

    context 'when additional methods have been added to implementation' do
      let(:implementation) do
        Interfacer.implement(:some_interface, for_class: for_class) do
          example_string do
            'foo'
          end

          example_integer do
            1
          end

          too_many_methods do
          end
        end
      end

      specify do
        expect { implement }
          .to raise_error(AdditionalMethodsDetected, include('[:too_many_methods]'))
      end
    end

    context 'when not all implementations have been written' do
      let(:implementation) do
        Interfacer.implement(:some_interface, for_class: for_class) do
          example_string do
            "some string"
          end
        end
      end

      specify do
        expect { implement }
          .to raise_error(MissingMethodsDetected, include('[:example_integer]'))
      end
    end
  end
end
