module DataMemory_tb();

    reg clk;
    reg MemWrite;
    reg MemRead;
    reg [31:0] address;
    reg [31:0] write_data;
    wire [31:0] read_data;

    DataMemory Instance_1(
        .clk(clk),
        .MemWrite(MemWrite),
        .MemRead(MemRead),
        .address(address),
        .write_data(write_data),
        .read_data(read_data)
    );

    always #5 clk = ~clk;

    integer i;
    initial begin

        
        
        
        for (i = 0; i < 64; i = i + 1) begin
            Instance_1.ram[i] = i * 4; 
        end


        $monitor("time=%0t | MemWrite = %b | MemRead = %b | read_data =%h",$time,MemWrite,MemRead,read_data);
        clk = 1'b0;
        MemRead = 1'b0;
        MemWrite = 1'b0;
        address = 32'd4;
        #10;
        MemRead = 1'b1;
        MemWrite = 1'b0;
        address = 32'd4;
        #10;
        MemRead = 1'b0;
        MemWrite = 1'b1;
        address = 32'd4;
        write_data = 32'd6;
        #10;
        MemRead = 1'b1;
        MemWrite = 1'b0;
        address = 32'd4;
        #10;
        $finish;

    end

endmodule
