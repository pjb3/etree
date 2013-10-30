require "bundler/setup"
Bundler.setup

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require "etree"
require "minitest/autorun"
