#
# Copyright 2018- Zsolt Fekete
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require "fluent/plugin/input"

module Fluent
  module Plugin
    class FilecountsInput < Fluent::Plugin::Input
      Fluent::Plugin.register_input("filecounts", self)
      helpers :timer

      def initialize
        super
      end

      desc 'The tag of the event.'
      config_param :tag, :string

      desc 'The path to monitor'
      config_param :path, :string

      desc 'The interval time between periodic request'
      config_param :interval, :time

      def start
        super

        timer_execute(:filecounts, @interval, &method(:on_timer))
      end

      def on_timer
        record = { "query_path" => @path }

        begin

          event_time = Time.now.strftime('%FT%T%:z')
          time_started = Engine.now
          command = "bash -c '\\find #@path -name \".*\" -prune -o -print'"
          files = IO.popen(command)
            .readlines.map(&:chomp)
          time_finished = Engine.now

        rescue StandardError => err
          record["error"] = err.message
        end

        es = MultiEventStream.new

        es.add(Engine.now, { "time" => event_time, "command" => command, "time_to_run" => (time_finished.to_i - time_started.to_i) })
        groups = files.group_by {|e| File.dirname(e) }
        counts = Hash[groups.map{|k,v| [k, v.count]}]
        time = Engine.now
        counts.each {|k,v| es.add(time, Hash[ 'time', event_time, 'path', k, 'count', v ]) }

        router.emit_stream(tag, es)

      end

      def shutdown
        super
      end

    end
  end
end
