# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tufts::WhitespaceNormalizer do
  subject(:normalizer) { described_class.new }

  describe '#strip_whitespace' do
    it 'returns non-string values unchanged' do
      expect(normalizer.strip_whitespace(:blah)).to eq :blah
    end

    it 'returns nil for an empty string' do
      expect(normalizer.strip_whitespace('')).to be_nil
    end

    it 'returns nil for a string that is empty after normalization' do
      expect(normalizer.strip_whitespace("   \n\r ")).to be_nil
    end

    it 'collapses whitespace into a single whitespace' do
      expect(normalizer.strip_whitespace("moomin   \n\r moomin  \n\t\r"))
        .to eq 'moomin moomin'
    end

    context 'when keeping newlines' do
      it 'collapses whitespace into a single whitespace keeping \n' do
        string = "moomin   \n\n\r\n \t moomin  \n\t\r"

        expect(normalizer.strip_whitespace(string, keep_newlines: true))
          .to eq "moomin\n\n moomin"
      end
    end

    context 'when value is enumerable' do
      it 'maps normalization over the values' do
        values = ["moomi \n\t n  \n ", 'moomin', '   moomin', '', nil, :moomin]

        expect(normalizer.strip_whitespace(values))
          .to contain_exactly "moomi n", 'moomin', 'moomin', :moomin
      end

      it 'retains keep_newlines' do
        values = ["moomi \n\t n  \n ", 'moomin', '   moomin', '', nil, :moomin]

        expect(normalizer.strip_whitespace(values, keep_newlines: true))
          .to contain_exactly "moomi\n n", 'moomin', 'moomin', :moomin
      end
    end
  end
end
