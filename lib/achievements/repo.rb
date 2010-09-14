# encoding: utf-8

class Repo
  def initialize
    @achievements = []
    @commits_count = 0
  end
  
  attr_reader :achievements, :commits_count
  
  
  def method_missing(id, *args, &block)
    case(id.to_s)
    when /(.*)_count$/
      send($1).count
    else
      super
    end
  end
end
