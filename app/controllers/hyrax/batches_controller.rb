module Hyrax
  class BatchesController < ApplicationController
    before_action :check_permissions

    def index
      @batches = batch_query(start, stop)
      @batches_length = Batch.count
    end

    def create
      params['batch']['ids'] ||= params[:batch_document_ids]

      batch           = Batch.new(params.require(:batch).permit(ids: []))
      batch.creator   = current_user if current_user
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

      ##
      # @return [Array<BatchPresenter>]
      def batch_query(start, length)
        Batch.order("#{columns[order]} #{direction}").offset(start).limit(length).map { |batch| BatchPresenter.for(object: batch) }
      end

      ##
      # @return [Array]
      def columns
        [:id, :batchable_type, :user_id, :created_at, :ids, :status].freeze
      end

      ##
      # @return [Integer]
      def order
        return 0 if params[:order].nil?
        params[:order].to_unsafe_hash["0"]["column"].to_i
      end

      ##
      # @return [Integer]
      def direction
        return 'asc' if params[:order].nil?
        params[:order].to_unsafe_hash["0"]["dir"]
      end

      ##
      # @return [Integer]
      def start
        return 0 if params[:start].nil?
        params[:start].to_i
      end

      ##
      # @return [Integer]
      def stop
        return Batch.count if params[:length].nil?
        params[:length].to_i
      end
  end
end
