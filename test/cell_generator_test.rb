require File.join(File.dirname(__FILE__), *%w[test_helper])

#require 'rails/generators/test_unit'


#require '/home/nick/projects/rails/railties/lib/rails/test/isolation/abstract_unit'
require 'abstract_unit'

#require '/home/nick/projects/rails/railties/test/generators/generators_test_helper'
require 'rails/generators'
require 'rails_generators/cell/cell_generator'
module Rails
  def self.root
    @root ||= File.expand_path(File.join(File.dirname(__FILE__), '..', 'fixtures'))
  end
end


class CellGeneratorTest < Rails::Generators::TestCase
  destination File.join(Rails.root, "tmp")
  setup :prepare_destination
  tests ::Cells::Generators::CellGenerator
  
  
  context "Running script/generate cell" do
    context "Blog post latest" do
      should "create the standard assets" do
        
        require "#{app_path}/config/environment"  # we need Rails.application
        

        run_generator ["Blog", "post", "latest"]
        
        assert_file "app/cells/blog_cell.rb", /class BlogCell < Cell::Rails/
        assert_file "app/cells/blog/post.html.erb", %r(app/cells/blog/post\.html\.erb)
        assert_file "app/cells/blog/latest.html.erb", %r(app/cells/blog/latest\.html\.erb)

        #assert files.include?(fake_rails_root+"/app/cells/blog/post.html.erb")
        #assert files.include?(fake_rails_root+"/app/cells/blog/latest.html.erb")
        #assert files.include?(fake_rails_root+"/test/cells/blog_cell_test.rb")
      end
      
      should "create haml assets with --haml" do
        run_generator ["Blog", "post", "latest", "--haml"]
        files = (file_list - @original_files)
        assert files.include?(fake_rails_root+"/app/cells/blog_cell.rb")
        assert files.include?(fake_rails_root+"/app/cells/blog/post.html.haml")
        assert files.include?(fake_rails_root+"/app/cells/blog/latest.html.haml")
        assert files.include?(fake_rails_root+"/test/cells/blog_cell_test.rb")
      end
    end
  end
  
  private
  def fake_rails_root
    File.join(File.dirname(__FILE__), 'rails_root')  
  end
  
  def file_list
    Dir.glob(File.join(fake_rails_root, "**/*"))
  end 
end