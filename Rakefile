target_host = '146.185.138.148'
user = 'skammer'

task :default => [:upload]

desc "Upload to #{target_host}"
task :upload => :regen do
  sh "rsync -rv --delete _site/ #{ user }@#{ target_host }:~/static/homepage"
end

desc 'Regenerate the static site'
task :regen do
  sh 'jekyll build'
end
