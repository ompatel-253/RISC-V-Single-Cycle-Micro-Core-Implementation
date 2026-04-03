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
