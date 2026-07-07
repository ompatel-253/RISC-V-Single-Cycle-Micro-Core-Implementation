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
