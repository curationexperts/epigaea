class TuftsMyWorksSearchBuilder < Hyrax::My::WorksSearchBuilder
  # Override default behavior so admin users can see unpublished works in the dashboard
  def only_active_works(solr_parameters)
    solr_parameters[:fq] ||= []
    solr_parameters[:fq] << '-suppressed_bsi:true' unless current_user.admin?
    solr_parameters[:fq].delete("-suppressed_bsi:true") if current_user.admin?
  end
end
