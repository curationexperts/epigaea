RSpec.shared_examples 'a draftable model' do
  before do
    unless defined?(model)
      raise 'Define `model` with `let(:model)` before using the ' \
            'draftable model shared examples'
    end
  end

  describe '#draft'
  describe '#has_draft?'
end
