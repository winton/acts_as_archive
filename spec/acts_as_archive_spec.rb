require 'spec_helper'

describe ActsAsArchive do
  it "should" do
    [ 8, 0, 8 ].each { |v| $db.migrate(v) }
    a = Record.create
    a.destroy
  end
end
