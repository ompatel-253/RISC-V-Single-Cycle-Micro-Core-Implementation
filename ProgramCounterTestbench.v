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


module program_counter_tb ();

    reg clk;
    reg reset;
    reg [31:0] pc_next;
    wire [31:0] pc;
    
    program_counter instance_1 (
        .clk(clk),
        .reset(reset),
        .pc_next(pc_next),
        .pc(pc)
    );
    
    always #5 clk = ~clk;
    
    initial begin
        $monitor("Time = 0%t | reset = %b, pc_next = %d , pc = %d", $time,reset,pc_next,pc);
        clk = 1'b1;
        #8;
        reset = 1'b1;
        pc_next = 32'd9;
        #10;
        reset = 1'b0;
        pc_next = 32'd4;
        #3;
        pc_next = 32'd3;
        #7;
        reset = 1'b1;
        
        #70 $finish;
        
    end
    

endmodule

    
