require 'minitest_helper'

describe PostDecorator do

  before do
    # ApplicationController.new.set_current_view_context
    @post = FactoryGirl.create(:post)
    @decorated_post = PostDecorator.decorate(@post)
  end

  describe "show_link" do
    it "must link to the post's resource url" do
      @decorated_post.show_link.should == "<a href=\"/posts/#{ @post.id }\">Test Post #{ @post.id }</a>"
    end
  end
end
