class InetIp

	# From http://blog.sosedoff.com/2009/04/16/inet_ntoa-and-inet_aton-in-ruby/
	def self.inet_aton(ip)
	    ip.split(/\./).map{|c| c.to_i}.pack("C*").unpack("N").first
	end
 
	def self.inet_ntoa(n)
	    [n].pack("N").unpack("C*").join "."
	end
	
end