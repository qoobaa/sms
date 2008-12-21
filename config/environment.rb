RAILS_GEM_VERSION = '2.3.0' unless defined? RAILS_GEM_VERSION

require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.gem "rubyist-aasm", :lib => "aasm", :source => "http://gems.github.com"
  config.gem "haml", :source => "http://gems.github.com"
  config.gem "mislav-will_paginate", :lib => "will_paginate", :source => "http://gems.github.com"
  config.gem "authlogic"

  config.time_zone = 'UTC'
end
