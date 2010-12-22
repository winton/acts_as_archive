$root = File.expand_path('../../', __FILE__)
require "#{$root}/lib/acts_as_archive/gems"

ActsAsArchive::Gems.require(:spec)

require 'active_support/dependencies'
require 'active_wrapper'
require "#{$root}/lib/acts_as_archive"

ActiveSupport::Dependencies.autoload_paths << "#{$root}/spec/fixtures"

$db, $log, $mail = ActiveWrapper.setup(
  :base => File.dirname(__FILE__),
  :env => 'test'
)
$db.establish_connection

Dir["#{$root}/spec/fixtures/*.rb"].each do |path|
  require path
end

Spec::Runner.configure do |config|
end

def all_records
  [
    {
      :record => Record.all,
      :belongs_to => BelongsTo.all,
      :has_one => HasOne.all,
      :has_many => HasMany.all,
      :has_many_through => HasManyThrough.all,
      :has_many_through_through => HasManyThroughThrough.all,
      :has_one_through => HasOneThrough.all,
      :has_one_through_through => HasOneThroughThrough.all
    },
    {
      :record => Record::Archive.all,
      :belongs_to => BelongsTo::Archive.all,
      :has_one => HasOne::Archive.all,
      :has_many => HasMany::Archive.all,
      :has_many_through => HasManyThrough::Archive.all,
      :has_many_through_through => HasManyThroughThrough::Archive.all,
      :has_one_through => HasOneThrough::Archive.all,
      :has_one_through_through => HasOneThroughThrough::Archive.all
    }
  ]
end

def verify_attributes(records, options={})
  options[:exclude] ||= []
  records.each do |key, value|
    if !options[:exclude].include?(key) && (!options[:only] || options[:only].include?(key))
      value.each do |record|
        record[:string].should == 'string'
        record[:integer].should == 1
        record[:created_at].is_a?(::Time).should == true
        record[:updated_at].is_a?(::Time).should == true
      end
    end
  end
end

def verify_lengths(records, lengths, options={})
  options[:exclude] ||= []
  records.each do |key, value|
    if !options[:exclude].include?(key) && (!options[:only] || options[:only].include?(key))
      value.length.should == lengths[key]
    end
  end
end