module Tufts
  class MetadataService < Hyrax::FormMetadataService
    def self.multiple?(model_class, field)
      if [:title].include?(field.to_sym)
        false
      elsif [:rights_statement].include?(field.to_sym)
        true
      else
        super
      end
    end
  end
end
