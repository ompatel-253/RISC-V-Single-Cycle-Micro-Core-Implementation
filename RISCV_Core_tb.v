`timescale 1ns / 1ps

module tb_RISCV_Core();

    reg clk;
    reg reset;

    
    integer cycle_count;
    integer errors;


    RISCV_Core uut (
        .clk(clk),
        .reset(reset)
    );

    
    always #5 clk = ~clk;

    
    task check_reg;
        input [4:0] reg_num;
        input [31:0] expected_val;
        input [8*20:1] test_name;
        begin
            if (uut.RF_1.registers[reg_num] !== expected_val) begin
                $display("[FAIL] %0s | x%0d = %0d (0x%0h) | Expected: %0d (0x%0h)", 
                         test_name, reg_num, uut.RF_1.registers[reg_num], 
                         uut.RF_1.registers[reg_num], expected_val, expected_val);
                errors = errors + 1;
            end else begin
                $display("[PASS] %0s | x%0d = %0d", test_name, reg_num, expected_val);
            end
        end
    endtask

    
    initial begin
        clk = 0;
        reset = 1;
        cycle_count = 0;
        errors = 0;

        $display("=================================================");
        $display("     Starting RISC-V Core Unit Test Suite        ");
        $display("=================================================");

        // --------------------------------------------------------------
        // Program Loading (Hand-Assembled Hex Code)
        // --------------------------------------------------------------
        // 0: addi x1, x0, 15     -> x1 = 15          (0x00F00093)
        // 1: addi x0, x0, 99     -> x0 MUST stay 0   (0x06300013)
        // 2: addi x2, x0, -5     -> x2 = -5 (SignExt)(0xFFB00113)
        // 3: add  x3, x1, x2     -> x3 = 10          (0x002081B3)
        // 4: sw   x3, 4(x0)      -> RAM[1] = 10      (0x00302223)
        // 5: lw   x4, 4(x0)      -> x4 = 10          (0x00402203)
        // 6: beq  x3, x4, 2      -> Jump to instr 8  (0x00418463) [Taken]
        // 7: addi x5, x0, 111    -> Skipped          (0x06F00293)
        // 8: addi x5, x0, 222    -> x5 = 222         (0x0DE00293)
        // 9: beq  x1, x2, 2      -> Don't Jump       (0x00208463) [Not Taken]
        //10: addi x6, x0, 333    -> x6 = 333         (0x14D00313)

        uut.IM_1.memory[0]  = 32'h00F00093; 
        uut.IM_1.memory[1]  = 32'h06300013; 
        uut.IM_1.memory[2]  = 32'hFFB00113; 
        uut.IM_1.memory[3]  = 32'h002081B3; 
        uut.IM_1.memory[4]  = 32'h00302223; 
        uut.IM_1.memory[5]  = 32'h00402203; 
        uut.IM_1.memory[6]  = 32'h00418463; 
        uut.IM_1.memory[7]  = 32'h06F00293; 
        uut.IM_1.memory[8]  = 32'h0DE00293; 
        uut.IM_1.memory[9]  = 32'h00208463; 
        uut.IM_1.memory[10] = 32'h14D00313; 

        
        #15;
        if (uut.pc !== 32'b0) begin
            $display("[FAIL] PC did not reset to 0! PC = 0x%0h", uut.pc);
            errors = errors + 1;
        end else begin
            $display("[PASS] Reset Verification Success (PC = 0)");
        end

        reset = 0;
        $display("-------------------------------------------------");

        
        while (uut.pc < 32'h0000002C) begin // Run until PC reaches end of program
            @(posedge clk);
            #1; // Delay post clock edge for state settlement
            cycle_count = cycle_count + 1;

            $display("Cycle %2d | PC: 0x%08h | Instr: 0x%08h", 
                     cycle_count, uut.pc, uut.instruction);
        end

    
        $display("-------------------------------------------------");
        $display("               RUNNING ASSERTIONS                ");
        $display("-------------------------------------------------");

        check_reg(1, 32'd15,         "I-Type Positive Add ");
        check_reg(0, 32'd0,          "x0 Hardwire Zero Rule");
        check_reg(2, 32'hFFFFFFFB,   "Sign-Extension (-5) ");
        check_reg(3, 32'd10,         "R-Type ADD Execution");
        check_reg(4, 32'd10,         "Store / Load Flow   ");
        check_reg(5, 32'd222,        "BEQ Branch Taken    ");
        check_reg(6, 32'd333,        "BEQ Branch Untaken  ");

        // Memory Check
        if (uut.DM_1.ram[1] !== 32'd10) begin
            $display("[FAIL] RAM[1] Store Error! Data = %0d", uut.DM_1.ram[1]);
            errors = errors + 1;
        end else begin
            $display("[PASS] RAM[1] Word Store Verification Success");
        end

        // Summary Report
        $display("=================================================");
        if (errors == 0) begin
            $display("    ALL TESTS PASSED SUCCESSFULLY! (0 Errors)    ");
        end else begin
            $display("    TEST SUITE FAILED with %0d errors!          ", errors);
        end
        $display("=================================================");

        $finish;
    end

endmodule
