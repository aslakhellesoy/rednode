
desc "Run specs"
task :spec do
  begin
    require 'rspec/core/rake_task'
    RSpec::Core::RakeTask.new(:spec)

    RSpec::Core::RakeTask.new(:rcov) do |t|
      t.rcov = true
      t.rcov_opts = ['--exclude', 'spec,gems']
    end
  rescue LoadError => e
    puts "you must have rspec >= 2.0.0 beta19 installed to run the specs"
  end
end
