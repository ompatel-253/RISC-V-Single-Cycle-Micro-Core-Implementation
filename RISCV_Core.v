module RISCV_Core(

    input clk,
    input reset

);

    wire [31:0] pc_next;

    program_counter pC_1(
        .clk(clk),
        .reset(reset),
        .pc(pc),
        .pc_next(pc)
    );

    wire [31:0] pc;

    Instruction_Memory IM_1(
        .address(pc),
        .instruction(instruction)
    );

    wire [31:0] instruction;

    Instruction_Decoder ID_1(
        .instruction(instruction),
        .opcode(opcode),
        .rd(rd),
        .funct3(funct3),
        .rs1(rs1),
        .rs2(rs2),
        .funct7(funct7),
        .imm_ext(imm_ext)
    );

    wire [6:0] opcode;
    wire [4:0] rd;
    wire [2:0] funct3;
    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [6:0] funct7;
    wire [31:0] imm_ext;

    Main_Control_Unit MC1(
        .opcode(opcode),
        .RegWrite(RegWrite),
        .ALUSrc(ALUSrc),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .MemtoReg(MemtoReg),
        .Branch(Branch),
        .ALUOp(ALUOp)
    );

    wire RegWrite;
    wire ALUSrc;
    wire MemRead;
    wire MemWrite;
    wire MemtoReg;
    wire Branch;
    wire [1:0] ALUOp;

    wire funct7_b5;
    assign funct7_b5 = funct7[4];

    ALU_Control_Unit ALUCU_1 (
        .ALUOp(ALUOp),
        .funct3(funct3),
        .funct7_b5(funct7_b5),
        .alu_control(alu_control)
    );

    wire [3:0] alu_control;

    wire [31:0] dr_write_data;
    wire reg_write_en;

    RegisterFile RF_1(
        .sr_1_address(rs1),
        .sr_2_address(rs2),
        .sr_1_data(rs1_data),
        .sr_2_data(rs2_data),
        .dr_address(rd),
        .dr_write_data(dr_write_data),
        .clk(clk),
        .reset(reset),
        .reg_write_en(reg_write_en)
    );

    wire [31:0] rs1_data;
    wire [31:0] rs2_data;

    RegisterData_Or_Immediate_MUX MUX_1 (
        .ALUSrc(ALUSrc),
        .rs2_data(rs2_data),
        .imm_ext(imm_ext),
        .RegisterData_Or_Immediate_MUX_out(RegisterData_Or_Immediate_MUX_out)
    );

    wire [31:0] RegisterData_Or_Immediate_MUX_out

    Thirty_Two_bit_ALU ALU_1 (
        .A(rs1_data),
        .B(RegisterData_Or_Immediate_MUX_out),
        .alu_control(alu_control),
        .alu_result(alu_result),
        .zero(zero)
    );

    wire [31:0] alu_result;
    wire zero;

    DataMemory DM_1()
    





endmodule

















module program_counter (
    input clk,
    input reset,
    input [31:0] pc_next,
    output reg [31:0] pc
);

    always @(posedge clk) begin
        
        if (reset == 1'b1) begin
            pc <= 0;
        end else begin
            pc <= pc_next;
        end
    end

endmodule

module Instruction_Memory(
    input [31:0] address,
    output [31:0] instruction
);

    reg [31:0] memory [63:0];
    
    assign instruction = memory[address[31:2]];

    initial begin
        memory[0] = 32'h002081B3; // A placeholder R-type instruction
        memory[1] = 32'h00510233; // Another instruction
        memory[2] = 32'h00A00193; // A placeholder I-type instruction
        
    end

endmodule

module Instruction_Decoder (
    input [31:0] instruction,
    output [6:0] opcode,
    output [4:0] rd,
    output [2:0] funct3,
    output [4:0] rs1,
    output [4:0] rs2,
    output [6:0] funct7,
    output reg [31:0] imm_ext
);

    assign opcode = instruction[6:0];
    assign rd = instruction[11:7];
    assign funct3 = instruction[14:12];
    assign rs1 = instruction[19:15];

    assign rs2 = instruction[24:20];
    assign funct7 = instruction[31:25];

    always @(*) begin

        case (opcode)

            7'b0010011, 7'b0000011 : imm_ext = {{20{instruction[31]}}, instruction[31:20]}; 
            7'b0100011 : imm_ext = { {20{instruction[31]}}, instruction[31:25], instruction[11:7] };
            7'b1100011 : imm_ext = { {19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0 };
            default : imm_ext = 32'b0;
        
        endcase
    
    end

endmodule

module DataMemory (
    input clk,
    input MemWrite,
    input MemRead,
    input [31:0] address,
    input [31:0] write_data,
    output [31:0] read_data
);
    reg [31:0] ram [63:0]; 
    assign read_data = (MemRead) ? ram[address[31:2]] : 32'b0;

    always @(posedge clk) begin

        if (MemWrite == 1'b1) begin
            ram[address[31:2]] <= write_data;
        end 

    end

    
endmodule

module Main_Control_Unit(
    input [6:0] opcode,
    output reg RegWrite,
    output reg ALUSrc,
    output reg MemRead,
    output reg MemWrite,
    output reg MemtoReg,
    output reg Branch,
    output reg [1:0] ALUOp
);

    always @(*) begin

        case(opcode) 

            
            7'b0110011 : begin
                RegWrite = 1'b1;
                ALUSrc   = 1'b0;
                MemRead  = 1'b0;
                MemWrite = 1'b0;
                MemtoReg = 1'b0;
                Branch   = 1'b0;
                ALUOp    = 2'b10;
            end
            
            
            7'b0010011 : begin
                RegWrite = 1'b1;
                ALUSrc   = 1'b1;
                MemRead  = 1'b0;
                MemWrite = 1'b0;
                MemtoReg = 1'b0;
                Branch   = 1'b0;
                ALUOp    = 2'b11;
            end
            
           
            7'b0000011 : begin
                RegWrite = 1'b1;
                ALUSrc   = 1'b1;
                MemRead  = 1'b1;
                MemWrite = 1'b0;
                MemtoReg = 1'b1;
                Branch   = 1'b0;
                ALUOp    = 2'b00;
            end
            
            
            7'b0100011 : begin
                RegWrite = 1'b0;
                ALUSrc   = 1'b1; 
                MemRead  = 1'b0;
                MemWrite = 1'b1; 
                MemtoReg = 1'b0; 
                Branch   = 1'b0;
                ALUOp    = 2'b00;
            end

            
            7'b1100011 : begin
                RegWrite = 1'b0;
                ALUSrc   = 1'b0; 
                MemRead  = 1'b0;
                MemWrite = 1'b0;
                MemtoReg = 1'b0; 
                Branch   = 1'b1; 
                ALUOp    = 2'b01; 
            end
            
            
            default : begin
                RegWrite = 1'b0;
                ALUSrc   = 1'b0;
                MemRead  = 1'b0;
                MemWrite = 1'b0;
                MemtoReg = 1'b0;
                Branch   = 1'b0;
                ALUOp    = 2'b00;
            end  
        endcase

    end

endmodule

module ALU_Control_Unit (
    input [1:0] ALUOp,
    input [2:0] funct3,
    input funct7_b5,        
    output reg [3:0] alu_control
);

    always @(*) begin
       
        alu_control = 4'b0000; 

        case (ALUOp)
            
            2'b00: begin
                alu_control = 4'b0010; 
            end

           
            2'b01: begin
                alu_control = 4'b0110; 
            end

            
            2'b10: begin
                case (funct3)
                    3'b000: begin
                       
                        if (funct7_b5) 
                            alu_control = 4'b0110; 
                        else           
                            alu_control = 4'b0010; 
                    end
                    3'b110:  alu_control = 4'b0001; 
                    3'b111:  alu_control = 4'b0000; 
                    default: alu_control = 4'b0000; 
                endcase
            end

            
            2'b11: begin
                case (funct3)
                    3'b000:  alu_control = 4'b0010; 
                    3'b110:  alu_control = 4'b0001; 
                    3'b111:  alu_control = 4'b0000; 
                    default: alu_control = 4'b0000; 
                endcase
            end

            
            default: begin
                alu_control = 4'b0000; 
            end
        endcase
    end

endmodule

module Full_Adder (
    input a,
    input b,
    input carry_in,
    output s,
    output carry_out
);
    assign s = a ^ b ^ carry_in;
    assign carry_out = (a & b) | (carry_in & (a ^ b));
endmodule

module Thirty_Two_bit_Adder (
    input [31:0] number_1,
    input [31:0] number_2,
    input cin,
    output [31:0] num_out,
    output final_carry
);
    wire [32:0] carry_chain;
    assign carry_chain[0] = cin;

    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : adder_loop
            Full_Adder fa_inst (
                .a(number_1[i]),
                .b(number_2[i]),
                .carry_in(carry_chain[i]),
                .s(num_out[i]),
                .carry_out(carry_chain[i+1])
            );
        end
    endgenerate

    assign final_carry = carry_chain[32];
endmodule

module Thirty_Two_bit_ALU (
    input [31:0] A,
    input [31:0] B,
    input [3:0] alu_control,
    output reg [31:0] alu_result,
    output zero
);
    wire [31:0] selective_inverter;
    wire cin_selected;
    wire [31:0] sum_wire;
    wire carry_wire;

    assign selective_inverter = (alu_control == 4'b0110) ? ~B : B;
    assign cin_selected       = (alu_control == 4'b0110) ? 1'b1 : 1'b0;

    Thirty_Two_bit_Adder arithmetic_core (
        .number_1(A),
        .number_2(selective_inverter),
        .cin(cin_selected),
        .num_out(sum_wire),
        .final_carry(carry_wire)
    );

    assign zero = (alu_result == 32'b0);

    always @(*) begin
        
        alu_result = 32'b0;

        case (alu_control)
            4'b0010 : alu_result = sum_wire;                                  
            4'b0110 : alu_result = sum_wire;                                  
            4'b0000 : alu_result = A & B;                                     
            4'b0001 : alu_result = A | B;                                     
            4'b0111 : alu_result = ($signed(A) < $signed(B)) ? 32'd1 : 32'd0; 
            default : alu_result = 32'b0;                                     
        endcase
    end

endmodule

module RegisterFile (
    
    input [4:0] sr_1_address ,
    input [4:0] sr_2_address ,
    output [31:0] sr_1_data ,
    output [31:0] sr_2_data ,
    input [4:0] dr_address ,
    input [31:0] dr_write_data ,
    input clk,
    input reset,
    input reg_write_en
    
);

    reg [31:0] registers [31:0];
    
    assign sr_1_data = (sr_1_address == 5'b0) ? 32'b0 : registers[sr_1_address];
    assign sr_2_data = (sr_2_address == 5'b0) ? 32'b0 : registers[sr_2_address];
    
    integer i;
    
    always @(posedge clk) begin 
      
      if (reset) begin 
        for (i=0 ; i<32 ; i = i+1) begin 
          registers[i] <= 32'b0;
        end
      end else if  ((dr_address != 5'b0) && (reg_write_en != 1'b0)) begin 
        registers[dr_address] <= dr_write_data;
      end
      
    end

endmodule

module RegisterData_Or_Immediate_MUX(

    input ALUSrc,
    input [31:0] rs2_data,
    input [31:0] imm_ext,
    output [31:0] RegisterData_Or_Immediate_MUX_out

);

    assign RegisterData_Or_Immediate_MUX_out = (ALUSrc == 1'b1) ? imm_ext : rs2_data;

endmodule
