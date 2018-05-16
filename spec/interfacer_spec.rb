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
      expect(build.public_instance_methods).to include(:example_string, :example_integer)
      expect(build.private_instance_methods).to include(:example_private)
      expect { Class.new.extend(build).example_string }.to raise_error(NotImplementedError)
      expect { Class.new.extend(build).example_integer }.to raise_error(NotImplementedError)
      expect { Class.new.extend(build).send(:example_private) }.to raise_error(NotImplementedError)
    end
  end

  describe '.implement' do
    subject(:implement) do
      implementation
    end

    before do
      Interfacer.build(:some_interface) do
        def_public_methods(:example_string, :example_integer)
      end
    end

    context 'when interface does not exist' do
      let(:implementation) do
        Interfacer.implement(:non_existent_interface, for_class: :something_else)
      end

      specify { expect { implement }.to raise_error(MissingInterface, 'NonExistentInterface') }
    end

    context 'when interface does exist' do
      let(:implementation) do
        Interfacer.implement(:some_interface, for_class: :something_else) do
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
        Interfacer.implement(:some_interface, for_class: :something_else) do
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
        Interfacer.implement(:some_interface, for_class: :something_else) do
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
        Interfacer.implement(:some_interface, for_class: :something_else) do
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
        Interfacer.implement(:some_interface, for_class: :something_else) do
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
