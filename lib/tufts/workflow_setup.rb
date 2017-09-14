module Tufts
  class WorkflowSetup
    MIRA_WORKFLOW_NAME = 'mira_publication_workflow'.freeze

    def self.setup
      Tufts::WorkflowSetup.new.setup
    end

    def setup
      set_default_workflow
      grant_publish_role_to_admins
    end

    def set_default_workflow
      # This is the non-destructive way to ensure the default admin set and its
      # associated PermissionTemplate exist, even if the database has been reset
      # Cribbed from hyrax/lib/tasks/default_admin_set.rake
      begin
        AdminSet.find_or_create_default_admin_set_id
      rescue ActiveRecord::RecordNotUnique
        Rails.logger.debug "Tried to make default permission template but it already exists"
      end
      Hyrax::PermissionTemplate.create!(admin_set_id: AdminSet::DEFAULT_ID) unless Hyrax::PermissionTemplate.find_by(admin_set_id: AdminSet::DEFAULT_ID)
      permission_template = Hyrax::PermissionTemplate.find_by(admin_set_id: AdminSet::DEFAULT_ID)
      load_workflows unless permission_template.available_workflows.where(name: Tufts::WorkflowSetup::MIRA_WORKFLOW_NAME).first
      mira_publication_workflow = permission_template.available_workflows.where(name: Tufts::WorkflowSetup::MIRA_WORKFLOW_NAME).first
      # If the workflow is already active, calling activate! will *deactive* it
      return if permission_template.active_workflow == mira_publication_workflow
      Sipity::Workflow.activate!(permission_template: permission_template, workflow_id: mira_publication_workflow.id)
    end

    # Load the workflows from config/workflows
    # Does the same thing as `bin/rails hyrax:workflow:load`
    # Note: You MUST create an AdminSet (and its associated PermissionTemplate first)
    def load_workflows
      Hyrax::Workflow::WorkflowImporter.load_workflows(logger: Rails.logger)
      errors = Hyrax::Workflow::WorkflowImporter.load_errors
      abort("Failed to process all workflows:\n  #{errors.join('\n  ')}") unless errors.empty?
    end

    def grant_publish_role_to_admins
      workflow = AdminSet.find(AdminSet::DEFAULT_ID).active_workflow
      workflow.permission_template.access_grants.create(
        agent_type: 'group',
        agent_id: 'admin',
        access: Hyrax::PermissionTemplateAccess::MANAGE
      )
      publishing_role = Sipity::Role['publishing']
      workflow.update_responsibilities(role: publishing_role, agents: Hyrax::Group.new('admin'))
    end
  end
end
