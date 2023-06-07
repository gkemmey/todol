# litestack inits our queue when `Litejob` is included in `ActiveJob::QueueAdapters::LitejobAdapter::Job`.
# so, we define it with the options we want already inited, then requre litestack like normal.
#
# ref: https://github.com/oldmoe/litestack/blob/master/lib/active_job/queue_adapters/litejob_adapter.rb#L39
# ref: https://github.com/oldmoe/litestack/blob/master/lib/litestack/litejob.rb#L46
# ref: https://github.com/oldmoe/litestack/blob/master/lib/litestack/litejob.rb#L89
# ref: https://github.com/oldmoe/litestack/blob/master/lib/litestack/litejobqueue.rb#L57
# ref: https://github.com/oldmoe/litestack/blob/master/lib/litestack/litejob.rb#L85

module ActiveJob
  module QueueAdapters
    class LitejobAdapter
      class Job
        @options = YAML.load_file(Rails.root.join("config/litejob.yml"), aliases: true).
                        fetch(Rails.env, {}).
                        symbolize_keys
      end
    end
  end
end

require "litestack"

if defined?(ActionCable::SubscriptionAdapter::Litecable)
  module ActionCable
    module SubscriptionAdapter
      class Litecable < ::Litecable
        DEFAULT_OPTIONS.merge!(
          YAML.load_file(Rails.root.join("config/litecable.yml"), aliases: true).
               fetch(Rails.env, {}).
               symbolize_keys
        )
      end
    end
  end
end
