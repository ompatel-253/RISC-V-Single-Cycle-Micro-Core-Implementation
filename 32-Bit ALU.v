module Full_Adder (
    input a,
    input b,
    input carry_in,
    output s,
    output carry_out
);
    assign s = a ^ b ^ carry_in;
    assign carry_out = (a & b) | (carry_in & (a ^ b));
endmodule

module Thirty_Two_bit_Adder (
    input [31:0] number_1,
    input [31:0] number_2,
    input cin,
    output [31:0] num_out,
    output final_carry
);
    
    wire [32:0] carry_chain;

    
    assign carry_chain[0] = cin;

    
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : adder_loop
            Full_Adder fa_inst (
                .a(number_1[i]),
                .b(number_2[i]),
                .carry_in(carry_chain[i]),
                .s(num_out[i]),
                .carry_out(carry_chain[i+1])
            );
        end
    endgenerate

    
    assign final_carry = carry_chain[32];
    
endmodule

module ALU (
    input [31:0] a,
    input [31:0] b,
    input [2:0] sel,
    output reg [31:0] y,
    output reg carry
);
    wire [31:0] selective_inverter;
    wire cin_selected;
    wire [31:0] sum_wire;
    wire carry_wire;

    
    assign selective_inverter = (sel == 3'b001) ? ~b : b;
    assign cin_selected = (sel == 3'b001) ? 1'b1 : 1'b0;

    
    Thirty_Two_bit_Adder instance_1 (
        .number_1(a),
        .number_2(selective_inverter),
        .cin(cin_selected),
        .num_out(sum_wire),
        .final_carry(carry_wire)
    );

    always @(*) begin
        
        y = 32'b0;
        carry = 1'b0;
        
        case (sel)
            3'b000 : begin 
                y = sum_wire;
                carry = carry_wire;
            end    
            3'b001 : begin 
                y = sum_wire;
                carry = carry_wire;
            end
            3'b010 : y = a | b;  
            3'b011 : y = a & b;  
            3'b100 : y = a ^ b;  
            default : begin
                y = 32'b0;
                carry = 1'b0;
            end
        endcase
    end
endmodule
