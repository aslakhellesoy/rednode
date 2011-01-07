require 'bundler'
Bundler::GemHelper.install_tasks

task :default => :spec


task :clean do
  sh "rm -rf pkg"
end

for lib in Dir["tasks/*.rake"]
  load lib
end