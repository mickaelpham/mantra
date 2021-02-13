# typed: true
# frozen_string_literal: true

APP_ENV = ENV.fetch('APP_ENV', 'development')

require 'forwardable'
require 'sorbet-runtime'
require 'zeitwerk'

require_relative 'database'

loader = Zeitwerk::Loader.new
loader.push_dir('app/models')
loader.push_dir('app/repositories')
loader.inflector.inflect('sku' => 'SKU')
loader.setup
