module Tufts
  class WorkflowSetup
    def set_default_workflow
      # This is the non-destructive way to ensure the default admin set and its
      # associated PermissionTemplate exist, even if the database has been reset
      # Cribbed from hyrax/lib/tasks/default_admin_set.rake
      id = AdminSet.find_or_create_default_admin_set_id
      Hyrax::PermissionTemplate.create(admin_set_id: AdminSet::DEFAULT_ID)
      load_workflows
      permission_template = Hyrax::PermissionTemplate.find_by(admin_set_id: id)
      mira_publication_workflow = permission_template.available_workflows.where(name: "mira_publication_workflow").first
      Sipity::Workflow.activate!(permission_template: permission_template, workflow_id: mira_publication_workflow.id)
      grant_approval_to_admins(mira_publication_workflow)
    end

    # Load the workflows from config/workflows
    # Does the same thing as `bin/rails hyrax:workflow:load`
    # Note: You MUST create an AdminSet (and its associated PermissionTemplate first)
    def load_workflows
      Hyrax::Workflow::WorkflowImporter.load_workflows(logger: Rails.logger)
      errors = Hyrax::Workflow::WorkflowImporter.load_errors
      abort("Failed to process all workflows:\n  #{errors.join('\n  ')}") unless errors.empty?
    end

    def grant_approval_to_admins(workflow)
      workflow.permission_template.access_grants.create(
        agent_type: 'group',
        agent_id: 'admin',
        access: Hyrax::PermissionTemplateAccess::MANAGE
      )
      approving_role = Sipity::Role['Approving']
      workflow.update_responsibilities(role: approving_role, agents: Hyrax::Group.new('admin'))
    end
  end
end
