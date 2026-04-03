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





module tb_RegisterFile();
    
    reg [4:0] sr_1_address, sr_2_address, dr_address;
    reg [31:0] dr_write_data;
    reg clk, reset, reg_write_en;
    
    
    wire [31:0] sr_1_data, sr_2_data;

    
    RegisterFile uut (
        .sr_1_address(sr_1_address),
        .sr_2_address(sr_2_address),
        .sr_1_data(sr_1_data),
        .sr_2_data(sr_2_data),
        .dr_address(dr_address),
        .dr_write_data(dr_write_data),
        .clk(clk),
        .reset(reset),
        .reg_write_en(reg_write_en)
    );

    
    always #5 clk = ~clk;

    initial begin
        
        clk = 0; reset = 1; reg_write_en = 0;
        sr_1_address = 0; sr_2_address = 0; dr_address = 0; dr_write_data = 0;
        
        $monitor("Time=%0t | x1=%h | x2=%h | x0=%h", $time, sr_1_data, sr_2_data,dr_write_data);

       
        #15 reset = 0; 

        
        #10;
        dr_address = 5'd1; 
        dr_write_data = 32'hDEADBEEF; 
        reg_write_en = 1;
        
        
        #10;
        dr_address = 5'd2; 
        dr_write_data = 32'hCAFEBABE;

        
        #10;
        reg_write_en = 0; 
        sr_1_address = 5'd1; 
        sr_2_address = 5'd2; 
        
        
        #10;
        dr_address = 5'd0; 
        dr_write_data = 32'hFFFFFFFF; 
        reg_write_en = 1;
        
        
        #10;
        reg_write_en = 0;
        sr_1_address = 5'd0; 

        
        #10;
        dr_address = 5'd1;
        dr_write_data = 32'h00000000;
        reg_write_en = 0; 
        
        #10;
        sr_1_address = 5'd1; 

        #20 $finish;
    end
endmodule
