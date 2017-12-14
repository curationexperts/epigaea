# Converts UploadedFiles into FileSets and attaches them to works.
class AttachTypedFilesToWorkJob < AttachFilesToWorkJob
  # @param [ActiveFedora::Base] work - the work object
  # @param [Array<Hyrax::UploadedFile>] uploaded_files - an array of files to attach
  def perform(work, uploaded_files, **work_attributes)
    validate_files!(uploaded_files)
    user = User.find_by_user_key(work.depositor) # BUG? file depositor ignored
    work_permissions = work.permissions.map(&:to_hash)
    metadata = visibility_attributes(work_attributes)
    uploaded_files.each do |uploaded_file|
      actor = Hyrax::Actors::FileSetActor.new(FileSet.create, user)
      actor.create_metadata(metadata)
      actor.create_content(uploaded_file)
      set_filetypes(work: work, file_set: actor.file_set, filename: uploaded_file.file.file.original_filename, **work_attributes)
      actor.attach_to_work(work)
      actor.file_set.permissions_attributes = work_permissions
      uploaded_file.update(file_set_uri: actor.file_set.uri)
    end
  end

  ##
  # Sets the file types on the work.
  #
  # Simply returns if no opts are passed. Otherwise, sets representative,
  # thumbnail, and transcript roles for the given fileset if filename matches
  # the set name for that role.
  #
  # If the work does not support a file type, attempts to set this relation are
  # ignored.
  #
  # @return [Boolean] true if the file types have been set sucessfully
  def set_filetypes(work:, file_set:, filename:, **opts)
    return true if opts.empty?

    [:representative, :thumbnail, :transcript].each do |type|
      work.public_send(:"#{type}_id=", file_set.id) if
        work.respond_to?(:"#{type}_id=") && opts[type] == filename
    end

    # NOTE: the work may not be valid, in which case this save doesn't do anything
    # see https://github.com/samvera/hyrax/blob/403d95cb2ada27fe366dd9e8df91240f3b46c461/app/actors/hyrax/actors/file_set_actor.rb#L81
    work.save
  end
end
