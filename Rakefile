require 'bundler/gem_tasks'
require 'rake/extensiontask'

spec = Gem::Specification.load('rpg-maker-vx-util.gemspec')
Rake::ExtensionTask.new('rgss3', spec)

task :default => [:compile, :build]
