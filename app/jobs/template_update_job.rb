##
# A job to apply a template to an existing object.
#
# @example
#   update = TemplateUpdate.create(ids: [object.id]
#   update.items.each do |item|
#     HandleRegisterJob.perform_later()
#
# @see ActiveJob::Base, HandleDispatcher.assign_for!
class TemplateUpdateJob < BatchableJob
  def perform(behavior, id, template_name)
    template = Tufts::Template.for(name: template_name, behavior: behavior)
    model    = ActiveFedora::Base.find(id)

    template.apply_to(model: model)
    model.save
  end
end
