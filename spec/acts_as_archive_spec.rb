require 'spec_helper'

describe ActsAsArchive do
  it "should" do
    [ 1, 0, 1 ].each { |v| $db.migrate(v) }
    a = Article.create
    a.destroy
  end
end
