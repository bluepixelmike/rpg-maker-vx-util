require 'bundler/gem_tasks'
require 'rake/extensiontask'

spec = Gem::Specification.load('rpg-maker-vx-util.gemspec')
Rake::ExtensionTask.new('rpg_maker_vx', spec)

task :default => [:compile, :build]
