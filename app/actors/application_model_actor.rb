##
# A base actor which model actors in this application should inherit from.
#
# @see Hyrax::Actors::ModelActor
class ApplicationModelActor < Hyrax::Actors::BaseActor
  ##
  # Extends BaseActor to reject attempts to create an item that already exists.
  #
  # @param [Hyrax::Actors::Environment] env
  # @return [Boolean] true if create was successful
  def create(env)
    return false unless env.curation_concern.new_record?
    super
  end
end
