# Set the CollectionsController to use our local CollectionForm

Rails.application.config.to_prepare do
  Hyrax::Dashboard::CollectionsController.form_class = Hyrax::CollectionForm
  Hyrax::Dashboard::CollectionsController.presenter_class = Hyrax::TuftsCollectionPresenter
  Hyrax::CollectionsController.presenter_class = Hyrax::TuftsCollectionPresenter
end
