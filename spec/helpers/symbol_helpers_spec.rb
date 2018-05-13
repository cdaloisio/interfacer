RSpec.describe Symbol do
  describe '#classify' do
    subject(:sym_to_classified_string) { :test_class_name.classify }

    it { is_expected.to eq 'TestClassName' }
  end
end
