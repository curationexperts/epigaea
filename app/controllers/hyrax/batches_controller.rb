module Hyrax
  class BatchesController < ApplicationController
    before_action :check_permissions

    def index
      start = params[:start].to_i
      length = params[:length].to_i

      @batches = batch_query(start, length)
      @batches_length = Batch.all.length
    end

    def create
      params['batch']['ids'] ||= params[:batch_document_ids]

      batch           = Batch.new(params.require(:batch).permit(ids: []))
      batch.batchable = BatchTask.new(batchable_params)
      batch.save

      batch.enqueue!

      redirect_to main_app.batch_path(batch)
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

      def batch_query(start, length)
        Batch.order("#{columns[order]} #{direction}").offset(start).limit(length).map { |batch| BatchPresenter.for(object: batch) }
      end

      def columns
        [:id, :batchable_type, :user_id, :created_at, :ids, :status]
      end

      def order
        return 0 if params[:order].nil?
        params[:order].to_unsafe_hash["0"]["column"].to_i
      end

      def direction
        return 'asc' if params[:order].nil?
        params[:order].to_unsafe_hash["0"]["dir"]
      end
  end
end
