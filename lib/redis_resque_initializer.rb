require "yaml"

module RedisResqueInitializer
  
  def initialize_redis_and_resque( app_root = ".", app_env = "development" )
    
    # redis
    # @see https://github.com/ezmobius/redis-rb
    # redis options:
    # host        default "127.0.0.1"
    # port        default 6379
    # db          default 0
    # timeout     default 5
    # password    no default
    # logger      no default
    # thread_safe no default; necessary for threaded environments; what about fibered environments?

    # redis-namespace
    # @see https://github.com/defunkt/redis-namespace
    # namespace options:
    # namespace   no default

    yml    = YAML.load( IO.read( "#{app_root}/config/redis.yml" ) ) [ app_env ]
    config = Hash[ yml.map { |k,v| [ k.to_sym, v ] } ] # mlanett 2011-02 poor man's symbolize_keys

    redis  = Redis.connect( config )
    STDERR.puts "[#{Process.pid}] redis_resque_initializer: connecting to #{config.inspect}"

    if namespace = config[:namespace] then
      $redis = Redis::Namespace.new( namespace, :redis => redis )
    else
      $redis = redis
    end

    # Support Phusion Passenger smart spawning/forking mode.
    # Reset the connection so it isn"t accidentally shared between multiple processes.
    begin
       PhusionPassenger.on_event(:starting_worker_process) do |forked|
         if forked
           $redis.client.reconnect
           STDERR.puts "[#{Process.pid}] redis_resque_initializer: reconnected to #{config.inspect}"
         end
       end
    rescue ArgumentError, NameError => error
      # NameError: Ruby 1.8
      # ArgumentError: Ruby 1.9
      # This statement block intentionally left blank.
    end

    Resque.redis = $redis
    
  end # initialize
  
  extend RedisResqueInitializer
end
