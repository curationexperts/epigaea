# Override the default value from Hyrax::Admin::WorkflowsController so that
# the "review submissions" dashboard behaves as expected

Rails.application.config.to_prepare do
  Hyrax::Admin::WorkflowsController.deposited_workflow_state_name = 'published'
end
