namespace :tufts do
  task ci: ['tufts:rubocop', 'tufts:spec']
end
