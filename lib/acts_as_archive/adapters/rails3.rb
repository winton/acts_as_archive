if Rails.root.nil?
  class ActsAsArchiveRailtie < Rails::Railtie
    initializer "acts_as_archive" do
      ActsAsArchive.load_from_yaml(Rails.root)
    end
  end
else
  ActsAsArchive.load_from_yaml(Rails.root)
end