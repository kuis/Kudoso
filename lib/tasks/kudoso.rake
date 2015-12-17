namespace 'kudoso' do
  desc 'Memorialize Tasks'
  task 'memorialize_tasks' => :environment do
    Family.memorialize_todos
  end
end
