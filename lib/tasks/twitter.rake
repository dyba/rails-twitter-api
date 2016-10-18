Rails::TestTask.new("test:twitter" => "test:prepare") do |t|
  t.pattern = "test/twitter/*_test.rb"
end

Rake::Task["test:run"].enhance ["test:twitter"]
