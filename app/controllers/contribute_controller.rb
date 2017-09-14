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
  end

  def create
    @contribution = @deposit_type.contribution_class.new(params[:contribution].merge(deposit_type: @deposit_type))

    if @contribution.save
      flash[:notice] = "Your deposit has been submitted for approval."
      redirect_to contributions_path
    else
      render :new
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
