module Main_Control_Unit(
    input [6:0] opcode,
    output reg RegWrite,
    output reg ALUSrc,
    output reg [1:0] ALUOp
);

    always @(*) begin

        case(opcode) 

            7'h33 : begin
                        RegWrite = 1'b1;
                        ALUSrc = 1'b0;
                        ALUOp = 2'b10;
                    end
            
            7'h13 : begin
                        RegWrite = 1'b1;
                        ALUSrc = 1'b1;
                        ALUOp = 2'b11;
                    end
            
            default : begin
                        RegWrite = 1'b0;
                        ALUSrc = 1'b0;
                        ALUOp = 2'b00;
                      end  
        endcase


    end

endmodule

module ALU_Control_Unit (
    input [1:0] ALUOp,
    input [2:0] funct3,
    input funct7_b5,        // Only bit 30 of the instruction! (bit 5 of funct7)
    output reg [3:0] alu_control
);

    always @(*) begin
        // 1. Global Pre-Assignment: Universal safety net to prevent latches
        alu_control = 4'b0000; 

        case (ALUOp)
            // Category 00: Memory Operations (Load/Store) -> Always forces ADD
            2'b00: begin
                alu_control = 4'b0010; 
            end

            // Category 01: Branch Operations (e.g., BEQ) -> Always forces SUB
            2'b01: begin
                alu_control = 4'b0110; 
            end

            // Category 10: R-Type Operations -> Inspects funct3 and funct7_b5
            2'b10: begin
                case (funct3)
                    3'b000: begin
                        // The Bit 30 Trick: High bit distinguishes ADD from SUB
                        if (funct7_b5) 
                            alu_control = 4'b0110; // Subtract (sub)
                        else           
                            alu_control = 4'b0010; // Addition (add)
                    end
                    3'b110:  alu_control = 4'b0001; // Bitwise OR  (or)
                    3'b111:  alu_control = 4'b0000; // Bitwise AND (and)
                    default: alu_control = 4'b0000; // Inner Fallback
                endcase
            end

            // Category 11: I-Type Operations -> Inspects funct3 only
            2'b11: begin
                case (funct3)
                    3'b000:  alu_control = 4'b0010; // Add Immediate (addi)
                    3'b110:  alu_control = 4'b0001; // OR Immediate  (ori)
                    3'b111:  alu_control = 4'b0000; // AND Immediate (andi)
                    default: alu_control = 4'b0000; // Inner Fallback
                endcase
            end

            // Outer Default Fallback
            default: begin
                alu_control = 4'b0000; 
            end
        endcase
    end

endmodule
