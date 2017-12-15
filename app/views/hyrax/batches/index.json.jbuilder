json.draw params[:draw]
json.recordsTotal @batches_length
json.recordsFiltered @batches_length
json.data do
  json.array! @batches.collect { |b| ["<a href='/batches/#{b.id}'>#{b.id}</a>", b.type, b.creator, b.created_at.to_formatted_s(:short), b.count, b.status] }
end
