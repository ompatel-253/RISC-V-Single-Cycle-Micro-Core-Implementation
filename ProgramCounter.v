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

    
