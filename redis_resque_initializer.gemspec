# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "redis_resque_initializer/version"

Gem::Specification.new do |s|
  s.name        = "redis_resque_initializer"
  s.version     = RedisResqueInitializer::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Mark Lanett"]
  s.email       = ["mark.lanett@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Initializes Redis and Resque}
  s.description = %Q{RedisResqueInitializer.initialize_redis_and_resque( ::Rails.root.to_s, ::Rails.env.to_s )}
  
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_dependency "redis"
  s.add_dependency "redis-namespace"
  s.add_dependency "resque"
end
