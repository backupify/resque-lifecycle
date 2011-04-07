require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'set'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'resque-lifecycle'

module ResqueMock
  extend self
  @items = {}

  def clear
    @items = {}
  end

  def push(queue, item)
    @items[queue] ||= []
    @items[queue].push(item)
    item
  end

  def pop(queue)
    @items[queue] ||= []
    @items[queue].pop
  end

end

class RedisMock

  def self.instance
    @@instance ||= RedisMock.new
  end

  def sadd(key, value)
    @sets[key] = Set.new unless @sets[key]
    @sets[key] << value
  end

  def sismember(key, value)
    return false unless @sets[key]

    @sets[key].include? value
  end

  private

  def initialize
    @sets = {}
  end

end

module Resque

  def self.redis
    RedisMock.instance
  end

end
