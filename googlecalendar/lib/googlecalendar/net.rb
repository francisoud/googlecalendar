require 'net/http'
require 'net/https'

#
# Make it east to use some of the convenience methods using https
#
module Net
  class HTTPS < HTTP
    def initialize(address, port = nil)
      super(address, port)
      self.use_ssl = true
    end
  end
end
