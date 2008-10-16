require File.dirname(__FILE__) + '/../../../../test/test_helper'
require File.dirname(__FILE__) + '/testing_helper'

# usually done by rails' autoloading:
require File.dirname(__FILE__) + '/cells/test_cell'


class CellsCachingTest < Test::Unit::TestCase
  include CellsTestMethods
  
  def setup
    super
    @controller.session= {}
    @cc = CachingCell.new(@controller)
  end
  
  def cache_configured?; ActionController::Base.cache_configured?; end
  
  def self.path_to_test_views
    RAILS_ROOT + "/vendor/plugins/cells/test/views/"
  end
  
  
  def test_state_cached?
    assert @cc.state_cached?(:cached_state)
    assert ! @cc.state_cached?(:not_cached_state)
  end
  
  def test_version_proc_for_state
    assert_kind_of Proc, @cc.version_proc_for_state(:cached_state)
    assert ! @cc.version_proc_for_state(:not_cached_state)
  end
  
  def test_caching
    c = @cc.render_state(:cached_state)
    assert_equal c, "1 should remain the same forever!"
    
    ### FIXME: somehow this returns false, although there IS a cache store set.
    #return unless cache_configured?
    
    c = @cc.render_state(:cached_state)
    assert_equal c, "1 should remain the same forever!", ":cached_state was invoked again"
  end
  
  def test_cache_key
    assert_equal "cells/CachingCell/some_state", @cc.cache_key(:some_state)
    assert_equal "cells/CachingCell/some_state/param=9", @cc.cache_key(:some_state, :param => 9)
  end
  
  def test_render_state_without_caching
    c = @cc.render_state(:not_cached_state)
    assert_equal c, "i'm really static"
  end
end

class CachingCell < Cell::Base
  
  cache :cached_state
  
  def cached_state
    cnt = controller.session[:cache_count]
    cnt ||= 0
    cnt += 1
    "#{cnt} should remain the same forever!"
  end
  
  def not_cached_state
    "i'm really static"
  end
end