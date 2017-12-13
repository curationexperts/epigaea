
|  Group | MIRA-FC3 | UI Label | Attribute Name | Predicate | Type | Cardinality |
|  ------ | ------ | ------ | ------ | ------ | ------ | ------ |
|  Descriptive | Abstract | Abstract | abstract | ::RDF::Vocab::DC.abstract | string | multiple |
|  Administrative | Accrual Policy | Accrual Policy | accrual_policy | ::RDF::Vocab::DC.accrualPolicy | string | **singluar** |
|  Descriptive | Alternate Title | Alternative Title | alternative_title | ::RDF::Vocab::DC.alternative | string | multiple |
|  Administrative | Audience | Audience | audience | ::RDF::Vocab::DC.audience | string | **singluar** |
|  Descriptive | Bibliographic Citation | Bibliographic Citation | bibliographic_citation | ::RDF::Vocab::DC.bibliographicCitation | string | multiple |
|  Descriptive | Contributor | Contributor | contributor | ::RDF::Vocab::DC11.contributor (via Hyrax::BasicMetadata) | string | multiple |
|  Descriptive | Corporate Name | Corporate Name | corporate_name | ::RDF::Vocab::MADS.CorporateName | string | multiple |
|  Descriptive | Creator | Creator | creator | ::RDF::Vocab::DC11.creator (via Hyrax::BasicMetadata) | string | multiple |
|  Administrative | Creatordept | Creator department | creator_dept | ::Tufts::Vocab::Terms.creatordept | string | multiple |
|  Descriptive | Date Accepted | Date Accepted | date_accepted | ::RDF::Vocab::DC.dateAccepted | string | multiple |
|  Descriptive | Date Available | Date Available | date_available | ::RDF::Vocab::DC.available | string | multiple |
|  Descriptive | Date Copyrighted | Date Copyrighted | date_copyrighted | ::RDF::Vocab::DC.dateCopyrighted | string | multiple |
|  Descriptive | Date Created | Date Created | date_created | ::RDF::Vocab::DC.created (via Hyrax::BasicMetadata) | string | multiple |
|  Descriptive | Date Issued | Date Issued | date_issued | ::RDF::Vocab::EBUCore.dateIssued | string | multiple |
|  Descriptive | Date Modified | Date Modified | date_modified | ::RDF::Vocab::DC.dateModified (via Hyrax::CoreMetadata) | string | multiple |
|  Descriptive | Date Submitted | Date Submitted | date_uploaded | ::RDF::Vocab::DC.dateSubmitted (via Hyrax::CoreMetadata) | string | multiple |
|  Descriptive | Description | Description | description | ::RDF::Vocab::DC11.description (via Hyrax::BasicMetadata) | string | multiple |
|  Administrative | Displays in Portal | Displays In | displays_in | ::Tufts::Vocab::Terms.displays_in | controlled | multiple |
|  Administrative | Embargo | Embargo Note | embargo_note | ::RDF::Vocab:: premis.TermOfRestriction | string | **singluar** |
|  Administrative | Expiration Date (purchased assets) | End Date | end_date | ::RDF::Vocab::PREMIS.hasEndDate | string | **singluar** |
|  Descriptive | Extent | Extent | extent | ::RDF::Vocab::DC.extent | string | **singluar** |
|  Descriptive | Format | Format | format_label | ::RDF::Vocab::PREMIS.hasFormatName | string | multiple |
|  Descriptive | Funder | Funder | funder | ::RDF::Vocab::relators.fnd | string | multiple |
|  Descriptive | Genre | Genre | genre | ::RDF::Vocab::MADS.GenreForm | string | multiple |
|  Descriptive | Has Format | Has Format | has_format | ::RDF::Vocab::DC::hasFormat | string | multiple |
|  Descriptive | Has Part | Has Part | has_part | ::RDF::Vocab::DC::hasPart | string | multiple |
|  Descriptive | *n/a* | Held By | held_by | ::RDF::Vocab::Bibframe.heldBy | string | multiple |
|  Administrative | Internal Note | Internal Note | internal_note | ::Tufts::Vocab::Terms.internal_note | string | **singluar** |
|  Descriptive | Is Format Of | Is Format Of | is_format_of | ::RDF::Vocab::DC::isFormatOf | string | multiple |
|  Descriptive | Is Part Of | Is Part Of | is_part_of | ::RDF::Vocab::DC::isPartOf | string | multiple |
|  Descriptive | Is Replaced By | Is Replaced By | is_replaced_by | ::RDF::Vocab::DC.isReplacedBy | string | multiple |
|  Descriptive | Language | Language | language | ::RDF::Vocab::DC11.language (via Hyrax::BasicMetadata) | string | multiple |
|  Administrative | *the base fedora pid* | Legacy PID | legacy_pid | ::Tufts::Vocab::Terms.legacy_pid | string | **singluar** |
|  Descriptive | License | License | license | ::RDF::Vocab::DC.rights (via Hyrax::BasicMetadata) | string | multiple |
|  Descriptive | Permanent URL | Permanent URL | identifier | ::RDF::Vocab::DC.identifier (via Hyrax::BasicMetadata) | string | singluar |
|  Descriptive | Personal Name | Personal Name | personal_name | ::RDF::Vocab::MADS.PersonalName | string | multiple |
|  Descriptive | Date | Primary Date | primary_date | ::RDF::Vocab::DC11.date | string | multiple |
|  Descriptive | Provenance | Provenance | provenance | ::RDF::Vocab::DC.provenance | string | multiple |
|  Descriptive | Publisher | Publisher | publisher | ::RDF::Vocab::DC11.publisher (via Hyrax::BasicMetadata) | string | multiple |
|  Administrative | QR Note | QR Note | qr_note | ::Tufts::Vocab::Terms.qr_note | string | multiple |
|  Administrative | Rejection Reason | QR Rejection Reason | rejection_reason | ::Tufts::Vocab::Terms.rejection_reason | string | multiple |
|  Administrative | Quality Review Status | QR Status | qr_status | ::Tufts::Vocab::Terms.qr_status | string | multiple |
|  Administrative | Createdby | Record Created By | created_by | ::Tufts::Vocab::Terms.createdby | string | multiple |
|  Descriptive | Replaces | Replaces | replaces | ::RDF::Vocab::DC.replaces | string | multiple |
|  Descriptive | Type | Resource Type | resource_type | ::RDF::Vocab::DC.type (via Hyrax::BasicMetadata.type) | controlled | **singular** |
|  Administrative | Retention Period | Retention Period | *retention_period* | ::Tufts::Vocab::Terms.retention_period | string | **singluar** |
|  Descriptive | Rights | Rights | rights_statement | ::RDF::Vocab::EDM.rights (via Hyrax::BasicMetadata) | string | **singluar** |
|  Descriptive | Rights Holder | Rights Holder | rights_holder | ::RDF::Vocab::DC.rightsHolder | string | multiple |
|  Administrative | Rights Note | Rights Note | rights_note | ::RDF::Vocab::DC11.rights | string | multiple |
|  Descriptive | Source | Source | source | ::RDF::Vocab::DC.source (via Hyrax::BasicMetadata) | string | multiple |
|  Descriptive | Geographic Name | Spatial | geographic_name | ::RDF::Vocab::DC.spatial | string | multiple |
|  Administrative | Start Date | Start Date | admin_start_date | ::Tufts::Vocab::Terms.start_date | string | **singluar** |
|  Administrative | Steward | Steward | steward | ::Tufts::Vocab::Terms.steward | string | **singluar** |
|  Descriptive | Subject | Subject | subject | ::RDF::Vocab::DC11.subject (via Hyrax::BasicMetadata) | string | multiple |
|  Descriptive | Table of Contents | Table of Contents | table_of_contents | ::RDF::Vocab::DC.tableOfContents | string | multiple |
|  Descriptive | Temporal | Temporal | temporal | ::RDF::Vocab::DC.temporal | string | multiple |
|  Descriptive | Title | Title | title | [::RDF::Vocab::DC.title (via Hyrax::CoreMetadata.title)](https://github.com/samvera/hyrax/blob/master/app/models/concerns/hyrax/core_metadata.rb#L12-L14) | string | **singluar** |
|  Administrative | License | Tufts License | tufts_license | ::RDF::Vocab::DC.license | string | **singluar** |
|  Descriptive | Access Rights | Visiblity | *n/a* | Use Hydra Access Controls |  |  |