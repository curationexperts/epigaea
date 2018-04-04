# coding: utf-8
# Generated via
#  `rails generate hyrax:work Audio`
require 'rails_helper'

RSpec.describe Hyrax::AudiosController do
  describe 'normalize spaces before passing them to object creation methods' do
    let(:params) do
      {
        "utf8" => "✓",
        "audio" =>
        {
          "title" => " Space   non normalized  \t title    ",
          "accrual_policy" => "",
          "creator" => " Name   with  Spaces ",
          "bibliographic_citation" => [" bibliographic   citation   with     spaces    "],
          "rights_holder" => ["blah     \nspaces   "],
          "publisher" => ["Publisher  "],
          "description" => [" A short   description \n   with  wonky spaces.\r\n\r\n\r\nBut keep two newlines between paragraphs. "],
          "abstract" => [" A short   description \n   with  wonky spaces.\r\n\r\n\r\nBut keep two newlines between paragraphs. "]
        },
        "controller" => "hyrax/audios",
        "action" => "update"
      }
    end
    it "normalizes the text in the params hash" do
      described_class.new.normalize_whitespace(params)
      expect(params["audio"]["title"]).to eq "Space non normalized title"
      expect(params["audio"]["creator"]).to eq "Name with Spaces"
      expect(params["audio"]["accrual_policy"]).to eq nil
      expect(params["audio"]["bibliographic_citation"]).to contain_exactly("bibliographic citation with spaces")
      expect(params["audio"]["rights_holder"]).to contain_exactly("blah spaces")
      expect(params["audio"]["description"]).to contain_exactly("A short description\n with wonky spaces.\n\nBut keep two newlines between paragraphs.")
      expect(params["audio"]["abstract"]).to contain_exactly("A short description\n with wonky spaces.\n\nBut keep two newlines between paragraphs.")
    end
  end
end
