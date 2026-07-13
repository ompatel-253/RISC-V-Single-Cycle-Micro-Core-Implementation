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

module Thirty_Two_bit_ALU (
    input [31:0] A,
    input [31:0] B,
    input [3:0] alu_control,
    output reg [31:0] alu_result,
    output zero
);
    wire [31:0] selective_inverter;
    wire cin_selected;
    wire [31:0] sum_wire;
    wire carry_wire;

    assign selective_inverter = (alu_control == 4'b0110) ? ~B : B;
    assign cin_selected       = (alu_control == 4'b0110) ? 1'b1 : 1'b0;

    Thirty_Two_bit_Adder arithmetic_core (
        .number_1(A),
        .number_2(selective_inverter),
        .cin(cin_selected),
        .num_out(sum_wire),
        .final_carry(carry_wire)
    );

    assign zero = (alu_result == 32'b0);

    always @(*) begin
        
        alu_result = 32'b0;

        case (alu_control)
            4'b0010 : alu_result = sum_wire;                                  
            4'b0110 : alu_result = sum_wire;                                  
            4'b0000 : alu_result = A & B;                                     
            4'b0001 : alu_result = A | B;                                     
            4'b0111 : alu_result = ($signed(A) < $signed(B)) ? 32'd1 : 32'd0; 
            default : alu_result = 32'b0;                                     
        endcase
    end

endmodule
