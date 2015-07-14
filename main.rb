####################################################
####	MTとLFSRの乱数をファイルに吐くプログラム		####
####################################################
require 'securerandom'
require "./random_number_gen.rb"

fm1 = open("mt19937.txt" , "w")
fm2 = open("tt800.txt" , "w")
fl = open("lfsr.txt" , "w")

#初期シードの生成
seed = SecureRandom.hex(4).to_i(16)

mt = MT19937.new(seed)
lfsr = LFSR.new(seed)
tt800 = TT800.new(seed)

for i in 0 ... 100
	fm1.write(complement(mt.nextInt))		# nextIntで生成した乱数を32bitに補完した後 ファイルに書き込み
	fm2.write(complement(tt800.nextInt))
	fl.write(complement(lfsr.nextInt))
end

fm1.close
fm2.close
fl.close
