
task :clean do
  sh "rm -rf *.gem"
end

desc "build #{$gem.name}.gemspec"
task :gemspec => :clean do
  $gem.files = Rake::FileList.new("**/*").to_a
  File.open("#{$gem.name}.gemspec", "w") do |f|
    f.write($gem.to_ruby)
  end
end

desc "build gem"
task :gem => :gemspec do
  $gem.rubyforge_project = $gem.name
  Gem::Builder.new($gem).build
end