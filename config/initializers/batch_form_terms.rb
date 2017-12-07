# This sets up the correct terms for the batch works forms
Hyrax::Forms::BatchUploadForm.terms = Tufts::Terms.shared_terms
Hyrax::Forms::BatchUploadForm.terms -= [:title, :resource_type]
Hyrax::Forms::BatchUploadForm.required_fields = [:displays_in]
