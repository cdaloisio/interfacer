module Interfacer
  RSpec.describe Singleton do
    describe '.build' do
      context 'with base example' do
        subject(:build) do
          described_class.build(:configuration) do
            options do
              @options
            end
          end
        end

        specify do
          expect(build).to eq ConfigurationSingleton
          expect { build.new }.to raise_error NoMethodError
          expect(build.instance('options_value', 1, 2)).to be_a ConfigurationSingleton
          instance = build.instance
          expect(instance.options).to include 'options_value'
          expect(instance.options).to include 1
          expect(instance.options).to include 2
          expect(build.instance).to eq instance
        end
      end
    end
  end
end
