module Tufts
  class DraftController < ApplicationController
    protect_from_forgery with: :null_session

    def save_draft
      model = ActiveFedora::Base.find(params[:id])

      model_type = model_type(model)
      scalar_fix(model_type)
      delete_items.each do |item|
        params[model_type].delete(item)
      end
      
      model.assign_attributes(allowed_params(model_type))
      model.save_draft
      model.has_draft = 'true'
      puts model.id
      model.save
      render json: { status: "A draft was saved.", attributes: model.attributes.except!(*delete_items) }
    end

    def delete_draft
      model = ActiveFedora::Base.find(params[:id])
      model.delete_draft
      model.has_draft = 'false'
      model.save
      render json: { status: "Deleted the draft." }
    end

    private

    def allowed_params(model_type)
      params.require(model_type).permit!
    end

    def delete_items
      # Extra data in the form that's not needed for drafts
      ["admin_set_id", "member_of_collection_ids", "visibility_during_embargo",
       "embargo_release_date", "visibility_after_embargo", "visibility_during_lease",
       "lease_expiration_date", "visibility_after_lease", "visibility", "version", "id", "head", "tail"]
    end

    def scalar_fix(model_type)
      # Make the title & license arrays to avoid type erros
      params[model_type][:title] = [params[model_type][:title]]
      params[model_type][:tufts_license] = params[model_type][:tufts_license]
      params[model_type][:rights_statement] = [params[model_type][:rights_statement]]
    end

    def model_type(model)
      model.class.to_s.downcase.to_sym
    end
  end
end
