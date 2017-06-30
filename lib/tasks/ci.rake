namespace :epigaea do
  task ci: ['epigaea:rubocop', 'epigaea:spec']
end
