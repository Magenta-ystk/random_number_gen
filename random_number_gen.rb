####################################################
####	MTとLFSRの乱数をファイルに吐くプログラム		####
####################################################
require 'securerandom'
require 'matrix'
#require './phase_shifter.rb'

class LFSR

	def initialize( s , chainlength )
		# フェーズシフタの面積格納変数
		@pf_area = 0

		# 初期値を設定
		@bit = 0
		if s==nil then
			@lfsr = 5489
		else
			@lfsr = s
		end
		# 行列Mの生成と各チェーンに対するtapを計算

		# tap 32 30 29 の行列M
		# 本当は特性多項式を入力したらMを生成するメソッドが欲しい
		@m = Matrix[
		[1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
		[1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
		[0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0],
		[1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0],
		[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0],
		[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0],
		[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
		[1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
		]
		@xor = [0,
				0b10000000000000000000000000000000,
				0b01000000000000000000000000000000,
				0b00100000000000000000000000000000,
				0b00010000000000000000000000000000,
				0b00001000000000000000000000000000,
				0b00000100000000000000000000000000,
				0b00000010000000000000000000000000,
				0b00000001000000000000000000000000,
				0b00000000100000000000000000000000,
				0b00000000010000000000000000000000,
				0b00000000001000000000000000000000,
				0b00000000000100000000000000000000,
				0b00000000000010000000000000000000,
				0b00000000000001000000000000000000,
				0b00000000000000100000000000000000,
				0b00000000000000010000000000000000,
				0b00000000000000001000000000000000,
				0b00000000000000000100000000000000,
				0b00000000000000000010000000000000,
				0b00000000000000000001000000000000,
				0b00000000000000000000100000000000,
				0b00000000000000000000010000000000,
				0b00000000000000000000001000000000,
				0b00000000000000000000000100000000,
				0b00000000000000000000000010000000,
				0b00000000000000000000000001000000,
				0b00000000000000000000000000100000,
				0b00000000000000000000000000010000,
				0b00000000000000000000000000001000,
				0b00000000000000000000000000000100,
				0b00000000000000000000000000000010,
				0b00000000000000000000000000000001
			]

		# 各チェーンに対する行列M および XORを算出
		i = 2		# カウンタ
		while( i <= 32 )
			@m = calculate_matrix( @m , chainlength )
			var = "@xor_#{i}"
			eval("#{var} = calculate_taps( @m , i )")	# xor_#{i}にi本目のchainのtapsが格納
			i += 1
		end
		i = 0
		j = 0
		# てすと
		while(i < 32)
			while(j < 32)
				printf("%d ",@m[i,j])
				j += 1
			end
			printf("\n")
			j = 0
			i += 1
		end
	end

	# Mの階乗を計算
	def calculate_matrix( m , shift_length )

		m = (m ** shift_length).collect{|m|
			m % 2
		}
		return( m )

	end

	# 指定bit目のXORtapを算出する
	def calculate_taps( m , n )

		# tapを格納する配列
		taps = []
		i = 0	# カウンタ
		while( i < 32 )
			# 対応する行列の行要素が1ならtapに追加
			if( m[i,n-1] == 1 )
				taps.push(i+1)
			end
			i += 1
		end
		@pf_area += taps.length
		return( taps )

	end

	# n本目のチェーンのbitを返す
	def nextInt_shift( n )
		tmp = eval("@xor_#{n}")
		bit = 0		# shift後の値
		i = 0

		while( i < tmp.length )
			bit = bit ^ ((@lfsr & @xor[tmp[i]]) >> (32-tmp[i]))
			i += 1
		end
		p bit
		return( bit )

	end

	# taps = 32,22,2,1
	def nextInt

		# 32bitの乱数を生成
		@bit = (@lfsr & 0x00000001) ^ ((@lfsr & 0x00000400) >> 10) ^ ((@lfsr & 0x40000000) >> 30) ^ ((@lfsr & 0x80000000) >> 31);
		@lfsr = (@lfsr >> 1) | (@bit << 31)

		# 生成した乱数と，各チェーンのtapsを元にシフト後の乱数を生成
		lfsr_shift = ""		# シフト後のlfsr
		lfsr_tmp = @lfsr
		lfsr_tmp = complement(lfsr_tmp)
		i = 1	# カウンタ
		while( i <= 32 )
			case i
			when 1 then
				lfsr_shift = lfsr_tmp.slice(31).chr		# ruby1.8では文字コードが返ってくることに要注意！！だからエンコードする必要がある
			else
				lfsr_shift.insert( -i , nextInt_shift(i).to_s )	# LFSRに挿入
			end
			i += 1
		end

		return(lfsr_shift.to_i(2))
	end

	def nextInt_noshift

		# 32bitの乱数を生成
		@bit = (@lfsr & 0x00000001) ^ ((@lfsr & 0x00000004) >> 2) ^ ((@lfsr & 0x00000008) >> 3)
		@lfsr = (@lfsr >> 1) | (@bit << 31)
		return(@lfsr)

	end

	def return_area
		return( 3 * @pf_area )
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

lfsr = LFSR.new(nil,32)
