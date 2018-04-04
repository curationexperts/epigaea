# frozen_string_literal: true

require 'rails_helper'

# these tests are descriptive; deprecate this module eventually
RSpec.describe Tufts::Normalizer do
  subject(:controller) { klass.new }
  let(:klass)          { Class.new { include Tufts::Normalizer } }

  describe '.normalize_whitespace' do
    let(:klass) do
      Class.new do
        include Tufts::Normalizer

        def hash_key_for_curation_concern
          :concern
        end
      end
    end

    let(:params) do
      { concern:
        { 'string'           => "moomin   \n\t   ",
          'array_of_strings' => ['moomin', "moomin\t ", "moomin   \n\t   "],
          'description'      => "moomin  \n\t   papa",
          'abstract'         => ['moomin', "moomin\t ", "moomin  \n\t   papa"] } }
    end

    it 'edits the params with whitespace normalization' do
      expect { controller.normalize_whitespace(params) }
        .to change { params[:concern] }
        .to include('string'           => 'moomin', 'description' => "moomin \n papa",
                    'array_of_strings' => ['moomin', "moomin", "moomin"],
                    'abstract'         => ['moomin', "moomin", "moomin \n papa"])
    end
  end

  describe '.strip_whitespace' do
    context 'when the value is another type' do
      let(:param_value) { :blah }

      it 'returns the value unchanged' do
        expect(controller.strip_whitespace(param_value)).to eq :blah
      end
    end

    context 'when the value is a string' do
      it 'returns nil for an empty string' do
        expect(controller.strip_whitespace('')).to be_nil
      end

      it 'turns extended whitespace into a single space' do
        expect(controller.strip_whitespace("moomi \n\t n  \n ")).to eq "moomi n"
      end
    end

    context 'when the value an array' do
      it 'returns nil for an empty array' do
        expect(controller.strip_whitespace([])).to be_nil
      end

      it 'echos values when a simple string is the only member' do
        expect(controller.strip_whitespace(['moomin']))
          .to contain_exactly('moomin')
      end

      it 'turns extended whitespace into a single space mapped over array' do
        values = ["moomi \n\t n  \n ", 'moomin', '   moomin']

        expect(controller.strip_whitespace(values))
          .to contain_exactly 'moomi n', 'moomin', 'moomin'
      end

      it 'raises an error for non string values' do
        values = [Object.new]

        expect(controller.strip_whitespace(values))
          .to contain_exactly(*values)
      end
    end
  end

  describe '.strip_whitespace_keep_newlines' do
    context 'when the value is another type' do
      let(:param_value) { :blah }

      it 'returns the value unchanged' do
        expect(controller.strip_whitespace_keep_newlines(param_value))
          .to eq :blah
      end
    end

    context 'when the value is a string' do
      it 'returns nil for an empty string' do
        expect(controller.strip_whitespace_keep_newlines('')).to be_nil
      end

      it 'turns extended whitespace into a single space' do
        expect(controller.strip_whitespace_keep_newlines("moomi \n\t n  \n "))
          .to eq "moomi \n n"
      end
    end

    context 'when the value an array' do
      it 'returns nil for an empty array' do
        expect(controller.strip_whitespace_keep_newlines([])).to be_nil
      end

      it 'echos values when a simple string is the only member' do
        expect(controller.strip_whitespace_keep_newlines(['moomin']))
          .to contain_exactly('moomin')
      end

      it 'turns extended whitespace into a single space mapped over array' do
        values = ["moomi \n\t n  \n ", 'moomin', '   moomin']

        expect(controller.strip_whitespace_keep_newlines(values))
          .to contain_exactly "moomi \n n", 'moomin', 'moomin'
      end

      it 'raises an error for non string values' do
        values = [Object.new]

        expect(controller.strip_whitespace_keep_newlines(values))
          .to contain_exactly(*values)
      end
    end
  end
end
