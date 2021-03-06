#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

#define DIGITS 32

uint32_t reg;	// 符号無し32bit変数 レジスタ変数
// tap 32 30 29の行列M
int m[32][32] =
	{
	{1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
	{1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
	{0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0},
	{1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0},
	{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0},
	{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0},
	{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
	{1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
	};
int mn[32][32] = {};		// Mの階乗を格納する配列
int R[32][32] = {};			// 基準となるMのn階乗を格納する配列 初期値は単位行列
int taps[32][32] = {};		// 各スキャンチェーンに対応するXORの位置を格納する配列
int bin[33] = {0,
			0x80000000,0x40000000,0x20000000,0x10000000,
			0x08000000,0x04000000,0x02000000,0x01000000,
			0x00800000,0x00400000,0x00200000,0x00100000,
			0x00080000,0x00040000,0x00020000,0x00010000,
			0x00008000,0x00004000,0x00002000,0x00001000,
			0x00000800,0x00000400,0x00000200,0x00000100,
			0x00000080,0x00000040,0x00000020,0x00000010,
			0x00000008,0x00000004,0x00000002,0x00000001
			};

// グローバル変数R,M_32を初期化する関数
void initialize_matrix(void)
{
	int i;
	for(i = 0;i < DIGITS;i++){
		mn[i][i] = 1;
		R[i][i] = 1;
	}
}

// 行列のn階乗を計算する関数
// Rに計算結果が入る
// R = R * m をn回繰り返す
// ただし値は2の剰余が入る（PhaseShifterの仕様上）
void calculate_matrix(n){
	int i, j, k, l;

	for(l = 0;l < n;l++){
		//i行目の処理
		for (i = 0; i < DIGITS; i++){
			//i行目をTに記憶
			int T[32];
			for (k = 0; k < DIGITS; k++){
				T[k] = R[i][k];
			}
			//i行目の計算
			for (j = 0; j < DIGITS; j++) {
				//i行j列目を計算
				int tmp = 0;
				for (k = 0; k < DIGITS; k++){
					tmp += T[k] * m[k][j];
				}
			R[i][j] = tmp % 2;
			}
		}
	}

}

// 正方行列の乗算をする関数
void matrixmultiply(void)
{
	int tmp[DIGITS][DIGITS] = {};
	int i,j,k;

	for(i = 0;i < DIGITS;i++)
	{
		for(j = 0;j < DIGITS;j++)
		{
			for(k = 0;k < DIGITS;k++)
			{
				tmp[i][j] += mn[i][k] * R[k][j];
			}
		}
	}

	// 計算結果をtmpからmnにコピー 2の剰余
	for(i = 0;i < DIGITS;i++){
		for(j = 0;j < DIGITS;j++){
			mn[i][j] = (tmp[i][j] % 2);
		}
	}

}

// 階乗後の配列Rを参照して，
// n本目のスキャンチェーンに対応するxor対応位置を算出する関数
void calculate_taps(n)
{
	int i,j = 0;
	for(i = 0;i < 32;i++){
		// 対応する配列の行の値が1ならOXRを追加
		if(mn[i][n-1] == 1){
			taps[n-1][j] = i+1;		// n本目のOXRがtaps[n]に格納
			j++;
		}
	}
}

// initializes LFSR with a seed
void init_genrand(unsigned long s, int chainlength)
{
	// set seed
	reg = s & 0xffffffffUL;
	// initialize R
	initialize_matrix();
	//calculate_matrix(1);

	int i = 0;
	calculate_matrix(chainlength);	// 基準となる行列Mの32乗を計算

	// 行列Mの計算とtapsに対応するxorの設定
	for(i = 2;i <= 32;i++){
		matrixmultiply();			// mn = mn * M^32
		calculate_taps(i);
	}
}

// n本目のチェーンになるbitを返す関数
int nextInt_n(n){
	int tmp[32];	// チェーンに対応するOXRを格納する配列
	int bit = 0;
	int i;
	// tmp配列にn本目のチェーンのOXRを格納
	for(i = 0;i < 32;i++){
		tmp[i] = taps[n-1][i];
	}
	// bitの算出
	for(i = 0;i < 32;i++){
		if(tmp[i] != 0){
		bit = bit ^ ((reg & bin[tmp[i]]) >> (32-tmp[i]));
		}
	}
	//printf("%d",bit);
	return(bit);
}

// 乱数生成部 フェーズシフタ無し
unsigned long genrand_int32(void)
{
	uint32_t bit;

	// taps = 32,22,2,1
	bit = (reg & 0x00000001) ^ ((reg & 0x00000400) >> 10) ^ ((reg & 0x40000000) >> 30) ^ ((reg & 0x80000000) >> 31);
	reg = (reg >> 1) | (bit << 31);

	return(reg);

}

// 乱数生成部 フェーズシフタ有り
unsigned long genrand_int32_shift(void)
{
	uint32_t bit;	// 符号無し32bit変数 bit処理用
	uint32_t reg_shift;		// シフト後の32bit乱数
	int i;		// カウンタ

	// taps = 32,30,29 ← このtapsおかしくない？？？？？
	// taps  = 32,22,2,1
	bit = (reg & 0x00000001) ^ ((reg & 0x00000400) >> 10) ^ ((reg & 0x40000000) >> 30) ^ ((reg & 0x80000000) >> 31);

	reg = (reg >> 1) | (bit << 31);
	// 32bitの乱数完成 ここからフェーズシフトする

	// まず最上位ビット以外を全て0にする
	reg_shift = reg;
	reg_shift = reg_shift & 0x80000000;

	// Chain2~32本目までのbitがどのようになるのか計算 reg_shiftに反映
	for(i = 2;i <= 32;i++)
	{
		if(nextInt_n(i) == 1)
		{
			// n本目のチェーンが1なら対応するbitを1に
			reg_shift = reg_shift | bin [i];
		}
	}
	return(reg_shift);
}

// 符号無し32bit数値を2進数でファイルにwrite
void cv2bin( uint32_t n, FILE **fp ) {
    int i;

    for( i = DIGITS-1; i >= 0; i-- ) {
        fprintf(*fp, "%x", ( n >> i ) & 1 );
    }
    fprintf(*fp, "\n" );
}

// main 処理
int main(void)
{
	FILE *fp;	// file pointer
	// file open
	/*
	if ((fp = fopen("lfsr.dat","wb")) == NULL){
		printf("file open error!!\n");
		exit(EXIT_FAILURE);
	}
	*/
	if ((fp = fopen("lfsr.txt","w")) == NULL){
		printf("file open error!!\n");
		exit(EXIT_FAILURE);
	}

	init_genrand(0xffffffff,32);	// lfsrの作成
	int i,j;
	uint32_t rand_32;

	/*
	for(i = 0;i < 32;i++){
		for(j = 0;j < 32;j++){
			printf("%d ",mn[i][j]);
		}
		printf("\n");
	}
	*/

	/*
	printf("\nThis is Taps\n");
	for(i = 0;i < 32;i++){
		for(j = 0;j < 32;j++){
			printf("%d ",taps[i][j]);
		}
		printf("\n");
	}
	*/

	// ファイル書き込み
	for(i = 0;i < 0xff; i++){
		rand_32 = genrand_int32_shift();
		//fwrite($rand_32,sizeof(rand_32),1,fp);
		//printf("%x ",rand_32);
		cv2bin(rand_32, &fp);
	}
	return 0;
}
