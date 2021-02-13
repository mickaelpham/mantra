# typed: strict
# frozen_string_literal: true

require 'sorbet-runtime'
require 'zeitwerk'

APP_ENV = T.let(ENV.fetch('APP_ENV', 'development'), String)
require_relative 'database'

loader = Zeitwerk::Loader.new
loader.push_dir('app/models')
loader.push_dir('app/repositories')
loader.inflector.inflect('sku' => 'SKU')
loader.setup
