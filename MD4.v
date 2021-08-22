module MD4
(
	INPUT, OUTPUT
);

input		[15:0]	INPUT;
output	[127:0]	OUTPUT;
reg	[127:0]	OUTPUT;
reg	[31:0] 	X	[0:15];
reg	[31:0]	A;
reg	[31:0]	B;
reg	[31:0]	C;
reg	[31:0]	D;
reg	[31:0]	AA;
reg	[31:0]	BB;
reg	[31:0]	CC;
reg	[31:0]	DD;


function [31:0] F;
	input	[31:0] X, Y, Z;
	begin
		F = (X & Y) | (~X & Z);
	end
endfunction

function [31:0] G;
	input	[31:0] X, Y, Z;
	begin
		G = (X & Y) | (X & Z) | (Y & Z);
	end
endfunction

function [31:0] H;
	input	[31:0] X, Y, Z;
	begin
		H = X ^ Y ^ Z;
	end
endfunction

function [31:0] R1;
	input	[31:0] _A, _B, _C, _D, X;
	input	[5:0] S;
	reg [31:0]	TEMP;
	begin
		TEMP = (_A + F(_B, _C, _D) + X);
		R1 = ROTATE_LEFT(TEMP, S);
	end
endfunction

function [31:0] R2;
	input	[31:0] _A, _B, _C, _D, X;
	input	[5:0] S;
	reg [31:0]	TEMP;
	begin
		TEMP = (_A + G(_B, _C, _D) + X + 32'h5A_82_79_99);
		R2 = ROTATE_LEFT(TEMP, S);
	end
endfunction

function [31:0] R3;
	input	[31:0] _A, _B, _C, _D, X;
	input	[5:0] S;
	reg [31:0]	TEMP;
	begin
		TEMP = (_A + H(_B, _C, _D) + X + 32'h6E_D9_EB_A1);
		R3 = ROTATE_LEFT(TEMP, S);
	end
endfunction



function [31:0] ROTATE_LEFT;
	input [31:0] WORD;
	input [4:0]  COUNT;
	reg [31:0] RESULT;
	reg [4:0]	i;
	begin
		RESULT = WORD;
		for (i = 0; i < COUNT; i = i+1)
			RESULT = {RESULT[30:0], RESULT[31]};
		ROTATE_LEFT = RESULT;
	end
endfunction
	
reg	[5:0]	i;

always @(INPUT)
begin
	X[0] = {16'h00_80, INPUT[7:0], INPUT[15:8]};
	for (i=1; i<16; i=i+1)
		X[i] = {32'h0};
	X[14] = 32'h10;
	//Расширение и добавление в конец длины сообщения (16)
	//Инициализация MD-буфера
	A = 32'h67_45_23_01;
	B = 32'hEF_CD_AB_89;
	C = 32'h98_BA_DC_FE;
	D = 32'h10_32_54_76;
	
		AA = A;
		BB = B;
		CC = C;
		DD = D;

		//Раунд 1
		A = R1(A, B, C, D, X[0], 3);
		D = R1(D, A, B, C, X[1], 7);
		C = R1(C, D, A, B, X[2], 11);
		B = R1(B, C, D, A, X[3], 19);
		A = R1(A, B, C, D, X[4], 3);
		D = R1(D, A, B, C, X[5], 7);
		C = R1(C, D, A, B, X[6], 11);
		B = R1(B, C, D, A, X[7], 19);
		A = R1(A, B, C, D, X[8], 3);
		D = R1(D, A, B, C, X[9], 7);
		C = R1(C, D, A, B, X[10], 11);
		B = R1(B, C, D, A, X[11], 19);
		A = R1(A, B, C, D, X[12], 3);
		D = R1(D, A, B, C, X[13], 7);
		C = R1(C, D, A, B, X[14], 11);
		B = R1(B, C, D, A, X[15], 19);

		//Раунд 2	
		A = R2(A, B, C, D, X[0], 3);
		D = R2(D, A, B, C, X[4], 5);
		C = R2(C, D, A, B, X[8], 9);
		B = R2(B, C, D, A, X[12], 13);
		A = R2(A, B, C, D, X[1], 3);
		D = R2(D, A, B, C, X[5], 5);
		C = R2(C, D, A, B, X[9], 9);
		B = R2(B, C, D, A, X[13], 13);
		A = R2(A, B, C, D, X[2], 3);
		D = R2(D, A, B, C, X[6], 5);
		C = R2(C, D, A, B, X[10], 9);
		B = R2(B, C, D, A, X[14], 13);
		A = R2(A, B, C, D, X[3], 3);
		D = R2(D, A, B, C, X[7], 5);
		C = R2(C, D, A, B, X[11], 9);
		B = R2(B, C, D, A, X[15], 13);

		//Раунд 3
		A = R3(A, B, C, D, X[0], 3);
		D = R3(D, A, B, C, X[8], 9);
		C = R3(C, D, A, B, X[4], 11);
		B = R3(B, C, D, A, X[12], 15);
		A = R3(A, B, C, D, X[2], 3);
		D = R3(D, A, B, C, X[10], 9);
		C = R3(C, D, A, B, X[6], 11);
		B = R3(B, C, D, A, X[14], 15);
		A = R3(A, B, C, D, X[1], 3);
		D = R3(D, A, B, C, X[9], 9);
		C = R3(C, D, A, B, X[5], 11);
		B = R3(B, C, D, A, X[13], 15);
		A = R3(A, B, C, D, X[3], 3);
		D = R3(D, A, B, C, X[11], 9);
		C = R3(C, D, A, B, X[7], 11);
		B = R3(B, C, D, A, X[15], 15);

		A = A + AA;
		B = B + BB;
		C = C + CC;
		D = D + DD;

	//Смена порядка байтов
	A = ((A & 32'hFF) << 24) | ((A & 32'hFF00) << 8) | ((A & 32'hFF0000) >> 8) | ((A & 32'hFF000000) >> 24);
	B = ((B & 32'hFF) << 24) | ((B & 32'hFF00) << 8) | ((B & 32'hFF0000) >> 8) | ((B & 32'hFF000000) >> 24);
	C = ((C & 32'hFF) << 24) | ((C & 32'hFF00) << 8) | ((C & 32'hFF0000) >> 8) | ((C & 32'hFF000000) >> 24);
	D = ((D & 32'hFF) << 24) | ((D & 32'hFF00) << 8) | ((D & 32'hFF0000) >> 8) | ((D & 32'hFF000000) >> 24);

	OUTPUT = {A, B, C, D};
end

endmodule


