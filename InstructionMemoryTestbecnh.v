module Instruction_Memory_tb();

    reg [31:0] address;
    wire [31:0] instruction;

    Instruction_Memory instance_1 (
        .address(address),
        .instruction(instruction)
    );

    initial begin

        $monitor("Time = %0t | address = %d | instruction = %d",$time,address,instruction);
    
        address = 32'd0;
        #10;
        address = 32'd4;
        #10;
        address = 32'd8;
        #10;
        address = 32'd5;
        #10;
        $finish;

    end
        

endmodule
