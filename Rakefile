require 'bundler/gem_tasks'
require 'rake/extensiontask'

spec = Gem::Specification.load('rpg-maker-vx-util.gemspec')
Rake::ExtensionTask.new('rpg_maker_vx_core', spec)

task :default => [:compile, :build]
