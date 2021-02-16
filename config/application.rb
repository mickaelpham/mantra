# typed: false
# frozen_string_literal: true

require 'sorbet-runtime'
require 'zeitwerk'

# rubocop:disable Lint/OrAssignmentToConstant
APP_ENV ||= ENV.fetch('APP_ENV', 'development')
# rubocop:enable Lint/OrAssignmentToConstant

require_relative 'database'

loader = Zeitwerk::Loader.new
loader.push_dir('app/entities')
loader.push_dir('app/repositories')
loader.inflector.inflect(
  'sku' => 'SKU',
  'sku_repository' => 'SKURepository'
)
loader.setup
