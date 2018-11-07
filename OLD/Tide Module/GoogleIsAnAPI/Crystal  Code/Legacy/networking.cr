require "socket"


class IPv4
  
  @addr1 : Int16
  @addr2 : Int16
  @addr3 : Int16
  @addr4 : Int16
  @validated : Bool = false
  @isValid : Bool = false
  @isLocal : Bool
  @localIPType : Int16
  
  def initialize(addr1 : Int16 | String, addr2 : Int16 = 0, addr3 : Int16 = 0, addr4 : Int16 = 0)
     if typeof(addr1) == String
    		prefix : String = addr1.to_s
        begin
        	params = prefix.split('.')
    			raise "nil" if params.size > 4 #if there are more than 4 dots in the string
          addr1 = params[0].to_i16
          addr2 = params[1].to_i16
          addr3 = params[2].to_i16
          addr4 = params[3].to_i16
        rescue ex
          return nil
        end
    end
    @addr1 = addr1.to_i16
    @addr2 = addr2
    @addr3 = addr3
    @addr4 = addr4
		if addr1 == 192 || addr1 == 10 ||addr1 == 172
			@localIPType = addr1.to_i16
			@isLocal = true
		else
			@localIPType = 0
			@isLocal = false
		end
  end
  
  def validate() : Bool
    valid : Bool = Socket.ip? self.stringify
		@isValid = valid
		valid
  end
  
  def stringify() : String
    "#{@addr1}.#{@addr2}.#{@addr3}.#{@addr4}"
  end
end

ip : IPv4
validIPs = Array(IPv4).new
(0..255).each do |w|
  (0..255).each do |x|
    (0..255).each do |y|
      (0..255).each do |z|
  				ip = IPv4.new("#{w}.#{x}.#{y}.#{z}")
                validIPs << ip if ip.validate
                puts validIPs.size
      end
    end
  end
end


# spawn do
#   puts "Hello!"
# end

# Fiber.yield

# string = "43.42.24.42"
# ints = string.split('.')
# ints.each do |int|
#   int = int.to_i16
# end