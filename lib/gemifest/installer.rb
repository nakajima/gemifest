module Gemifest
  class Installer
    def initialize(gem)
      @gem = gem
    end

    def perform!
      begin
        $stdout = StringIO.new('')
        $stderr = StringIO.new('')
        with_progress 'Installing ' + @gem.name do
          `gem install --no-ri --no-rdoc #{@gem.line}`
        end
      ensure
        $stderr = STDERR
        $stdout = STDOUT
      end
    end

    private

    def with_progress(label)
      STDERR.print label
      begin
        t = Thread.new do
          loop do
            STDERR.print('.')
            STDERR.flush
            sleep 0.8
          end
        end
        yield
        STDERR.puts ' done!' unless $?.exitstatus > 0
      rescue => e
        STDOUT.puts "Error:"
        STDOUT.puts e.message
      ensure
        t.kill
      end
    end
  end
end
