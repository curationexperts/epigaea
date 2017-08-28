module Hyrax
  class BatchesController < ApplicationController
    def index
      @batches = Batch.all.map { |batch| BatchPresenter.for(object: batch) }
    end

    def show
      @batch = BatchPresenter.for(object: Batch.find(params[:id]))
    end
  end
end
