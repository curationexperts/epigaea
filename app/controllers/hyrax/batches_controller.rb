module Hyrax
  class BatchesController < ApplicationController
    before_action :check_permissions

    def index
      @batches = Batch.all.map { |batch| BatchPresenter.for(object: batch) }
    end

    def create
      params['batch']['ids'] ||= params[:batch_document_ids]

      batch           = Batch.new(params.require(:batch).permit(ids: []))
      batch.batchable = BatchTask.new(batchable_params)
      batch.save

      batch.enqueue!

      redirect_to main_app.batches_path action: 'show',
                                        id:     batch.id,
                                        notice: 'Batch Enqueued!'
    end

    def show
      @batch = BatchPresenter.for(object: Batch.find(params[:id]))
    end

    private

      def batch_params
        params.require(:batch).permit(ids: [])
      end

      def batchable_params
        params
          .require(:batch)
          .require(:batchable_attributes)
          .permit(:batch_type)
      end

      def check_permissions
        authorize! :create, Batch
      end
  end
end
