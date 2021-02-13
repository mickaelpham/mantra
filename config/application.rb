# typed: false
# frozen_string_literal: true

require 'zeitwerk'

loader = Zeitwerk::Loader.new
loader.push_dir('app/models')
loader.inflector.inflect('sku' => 'SKU')
loader.setup
