module Instruction_Decoder_tb();

    reg [31:0] instruction;
    wire [6:0] opcode;
    wire [4:0] rd;
    wire [2:0] funct3;
    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [6:0] funct7;
    wire [31:0] imm_ext;

    Instruction_Decoder instance_1(
        .instruction(instruction),
        .opcode(opcode),
        .rd(rd),
        .funct3(funct3),
        .rs1(rs1),
        .rs2(rs2),
        .funct7(funct7),
        .imm_ext(imm_ext)
    );

    initial begin
        $monitor("Time = %0t | instruction = %h | op = %h | rd=%d | rs1 = %d|rs2=%d|imm=%h",$time,instruction,opcode,rd,rs1,rs2,imm_ext);
        instruction = 32'h00A00193;
        #10;
        instruction = 32'hFF600213;
        #10;
        instruction = 32'h002081B3;
        $finish;
    end

endmodule
