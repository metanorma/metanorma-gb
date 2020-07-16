require "bundler/gem_tasks"
require "rspec/core/rake_task"
require 'isodoc/gem_tasks'

module IsoDoc
  module GemTasks
    module_function

    def fonts_placeholder
      <<~TEXT
        $bodyfont: '{{bodyfont}}';
        $headerfont: '{{headerfont}}';
        $monospacefont: '{{monospacefont}}';
        $titlefont: '{{titlefont}}';
      TEXT
    end
  end
end

IsoDoc::GemTasks.install
RSpec::Core::RakeTask.new(:spec)

task :default => :spec
