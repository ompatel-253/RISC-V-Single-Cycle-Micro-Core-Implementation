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
