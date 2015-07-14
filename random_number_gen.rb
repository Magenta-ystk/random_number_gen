####################################################
####	MTとLFSRの乱数をファイルに吐くプログラム		####
####################################################
require 'securerandom'

class LFSR

	def initialize(s)
		@bit = 0
		if s==nil then
			@lfsr = 5489
		else
			@lfsr = s
		end
	end

	def nextInt
		@bit = (@lfsr & 0x00000001) ^ ((@lfsr & 0x00000004) >> 2) ^ ((@lfsr & 0x00000008) >> 3)
		@lfsr = (@lfsr >> 1) | (@bit << 31)
		return(@lfsr)
	end

end

class MT19937
	def initialize(s)
		@N = 624
		@M = 397
		@CONST = [0,0x9908b0df]
		@MSB = 0x80000000
		@LSB = 0x7fffffff
		@i = 1
		@mt = Array.new(@N)
		if s==nil then
			@mt[0] = 5489 & 0xffffffff
		else
			@mt[0] = s & 0xffffffff
		end
		while @i<@N
			@mt[@i] = 1812433253 * (@mt[@i-1]^(@mt[@i-1]>>30)) + @i
			@mt[@i] &= 0xffffffff
			@i = @i+1
		end
	end

	def nextInt
		#Twisting
		if @i==@N then
			@twi=0
			while @twi < @N-@M
				@n = (@mt[@twi]&@MSB) | (@mt[@twi+1]&@LSB)
				@mt[@twi] = @mt[@twi+@M] ^ (@n>>1) ^ @CONST[@n&1]
				@twi += 1
			end
			while @twi < @N-1
				@n = (@mt[@twi]&@MSB) | (@mt[@twi+1]&@LSB)
				@mt[@twi] = @mt[@twi+@M-@N] ^ (@n>>1) ^ @CONST[@n&1]
				@twi += 1
			end
			@n = (@mt[@N-1]&@MSB) | (@mt[0]&@LSB)
			@mt[@N-1] = @mt[@M-1] ^ (@n>>1) ^ @CONST[@n&1]
			@i = 0
		end
		@i += 1

		#Tempering
		@n = @mt[@i-1]
		@n ^= (@n >> 11)
		@n ^= (@n << 7) & 0x9d2c5680
		@n ^= (@n << 15) & 0xefc60000
		@n ^= (@n >> 18)
		return @n&0xffffffff
	end
end

class TT800
	def initialize(s)
		@N = 25
		@M = 7
		@i = 1
		@mag = [0x0,0x8ebfd028]		# Magic Number
		@tt800 = Array.new(@N)
		if s == nil then
			@tt800 =
			[0x95f24dab, 0x0b685215, 0xe76ccae7, 0xaf3ec239, 0x715fad23,
			0x24a590ad, 0x69e4b5ef, 0xbf456141, 0x96bc1b7b, 0xa7bdf825,
			0xc1de75b7, 0x8858a9c9, 0x2da87693, 0xb657f9dd, 0xffdc8a9f,
			0x8121da71, 0x8b823ecb, 0x885d05f5, 0x4e20cd47, 0x5a9ad5d9,
			0x512c0c03, 0xea857ccd, 0x4cc1d30f, 0x8891a8a1, 0xa6b7aadb]
		else
			@tt800[0] = s & 0xffffffff
			while @i<@N
				@tt800[@i] = 1812433253 * (@tt800[@i-1]^(@tt800[@i-1]>>30)) + @i
				@tt800[@i] &= 0xffffffff
				@i = @i+1
			end
		end

	end

	def nextInt
		#Twisting
		if(@i == @N)
			k = 0
			while(k < @N - @M)
				@tt800[k] = @tt800[k+@M] ^ (@tt800[k] >> 1) ^ @mag[@tt800[k] % 2]
				k = k + 1
			end
			while(k < @N)
				@tt800[k] = @tt800[k + (@M-@N)] ^ (@tt800[k] >> 1) ^ @mag[@tt800[k] % 2]
				k = k + 1
			end
			@i = 0
		end

		#Tempering
		@n = @tt800[@i]
		@n ^= (@n << 7) & 0x2b5b2500
		@n ^= (@n << 15) & 0xdb8b0000
		@n &= 0xffffffff
		@n ^= (@n >> 16)
		@i = @i + 1
		return @n&0xffffffff
	end
end

# 文字列を32bitまで補完するモジュール
def complement( number )
	number = number.to_s(2)

	while(1)
		if number.size == 32
			break
		else
			number = number.insert(0,"0")
		end
	end

	return( number )

end
