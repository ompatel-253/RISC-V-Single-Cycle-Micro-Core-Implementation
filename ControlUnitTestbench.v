module Control_Unit_tb();

    reg [6:0] opcode;
    reg [2:0] funct3;
    reg funct7_b5;
    wire RegWrite;
    wire ALUSrc;
    wire [1:0] ALUOp;
    wire [3:0] alu_control;

    Main_Control_Unit instance_1 (
        .opcode(opcode),
        .RegWrite(RegWrite),
        .ALUSrc(ALUSrc),
        .ALUOp(ALUOp)
    );

    ALU_Control_Unit instance_2(
        .ALUOp(ALUOp),
        .funct3(funct3),
        .funct7_b5(funct7_b5),
        .alu_control(alu_control)
    );

    initial begin

        $monitor("Time = %0t | opcode = %h | ALUSrc = %b | RegWrite = %b | alu_control = %b",$time,opcode,ALUSrc,RegWrite,alu_control);

        opcode = 7'h33;
        funct3 = 3'b000;
        funct7_b5 = 1'b0;
        #10;
        opcode = 7'h33;
        funct3 = 3'b000;
        funct7_b5 = 1'b1;
        #10;
        opcode = 7'h13;
        funct3 = 3'b000;
        funct7_b5 = 1'b0;
        #10;
        opcode = 7'h7F;
        funct3 = 3'b111;
        funct7_b5 = 1'b1;
        #10;
        $finish;

    end


endmodule
