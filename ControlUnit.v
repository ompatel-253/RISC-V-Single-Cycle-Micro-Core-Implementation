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
