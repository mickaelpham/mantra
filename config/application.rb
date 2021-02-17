# typed: false
# frozen_string_literal: true

require 'set'
require 'sorbet-runtime'
require 'zeitwerk'

# rubocop:disable Lint/OrAssignmentToConstant
APP_ENV ||= ENV.fetch('APP_ENV', 'development')
# rubocop:enable Lint/OrAssignmentToConstant

require_relative 'database'

loader = Zeitwerk::Loader.new

# Add directories to be loaded
loader.push_dir('app/entities')
loader.push_dir('app/mediators')
loader.push_dir('app/repositories')

# Inflect acronyms
loader.inflector.inflect(
  'sku' => 'SKU',
  'sku_repository' => 'SKURepository'
)

loader.setup
