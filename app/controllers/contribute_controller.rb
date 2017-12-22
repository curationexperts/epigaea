class ContributeController < ApplicationController
  include GisHelper

  before_action :load_deposit_type, only: [:new, :create]

  def index; end

  def redirect # normal users calling '/' should be redirected to ''/contribute'
    redirect_to contributions_path
  end

  def license; end

  def new
    @contribution = @deposit_type.contribution_class.new
    @contribution.creator = current_user.display_name
  end

  def create
    normalize_whitespace(params)
    @contribution = @deposit_type.contribution_class.new(
      params[:contribution].merge(deposit_type: @deposit_type).merge(depositor: current_user.user_key)
    )

    if @contribution.save
      flash[:notice] = "Your deposit has been submitted for approval."
      Hyrax::Workflow::SelfDepositNotification.new(@contribution.tufts_pdf).call
      redirect_to contributions_path
    else
      render :new
    end
  end

  # Go through the params hash and normalize whitespace before handing it off to
  # object creation
  # @param [ActionController::Parameters] params
  def normalize_whitespace(params)
    # For keep_newline_fields, keep single newlines, compress 2+ newlines to 2,
    # and otherwise strip whitespace as usual
    keep_newline_fields = ['description', 'abstract']
    params["contribution"].keys.each do |key|
      next unless params["contribution"][key].class == String
      params["contribution"][key] = if keep_newline_fields.include?(key)
                                      params["contribution"][key].gsub(/[ \t]+?[\n]{2,}[ \t]+?/, "\n\n").gsub(/[ \t]+/, " ").strip
                                    else
                                      params["contribution"][key].gsub(/\s+/, " ").strip
                                    end
    end
  end

protected

  def load_deposit_type
    @deposit_type = DepositType.where(id: params[:deposit_type]).first
    # Redirect the user to the selection page if the deposit type is invalid or missing
    unless @deposit_type # rubocop:disable Style/GuardClause
      flash[:error] = "Please select a deposit type from the dropdown menu."
      redirect_to contributions_path
    end
  end
end
