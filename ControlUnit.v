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
