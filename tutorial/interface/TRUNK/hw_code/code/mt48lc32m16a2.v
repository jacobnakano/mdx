//test
//test
module mt48lc32m16a2 (Dq, Addr, Ba, Clk, Cke, Cs_n, Ras_n, Cas_n, We_n, Dqm);

    parameter addr_bits =      13;
    parameter data_bits =      16;
    parameter col_bits  =      10;
    parameter mem_sizes = 8388607;

    inout     [data_bits - 1 : 0] Dq;
    input     [addr_bits - 1 : 0] Addr;
    input                 [1 : 0] Ba;
    input                         Clk;
    input                         Cke;
    input                         Cs_n;
    input                         Ras_n;
    input                         Cas_n;
    input                         We_n;
    input                 [1 : 0] Dqm;

    reg       [data_bits - 1 : 0] Bank0 [0 : mem_sizes];
    reg       [data_bits - 1 : 0] Bank1 [0 : mem_sizes];
    reg       [data_bits - 1 : 0] Bank2 [0 : mem_sizes];
    reg       [data_bits - 1 : 0] Bank3 [0 : mem_sizes];

    reg                   [1 : 0] Bank_addr [0 : 3];                // Bank Address Pipeline
    reg        [col_bits - 1 : 0] Col_addr [0 : 3];                 // Column Address Pipeline
    reg                   [3 : 0] Command [0 : 3];                  // Command Operation Pipeline
    reg                   [1 : 0] Dqm_reg0, Dqm_reg1;               // DQM Operation Pipeline
    reg       [addr_bits - 1 : 0] B0_row_addr, B1_row_addr, B2_row_addr, B3_row_addr;

    reg       [addr_bits - 1 : 0] Mode_reg;
    reg       [data_bits - 1 : 0] Dq_reg, Dq_dqm;
    reg        [col_bits - 1 : 0] Col_temp, Burst_counter;

    reg                           Act_b0, Act_b1, Act_b2, Act_b3;   // Bank Activate
    reg                           Pc_b0, Pc_b1, Pc_b2, Pc_b3;       // Bank Precharge

    reg                   [1 : 0] Bank_precharge       [0 : 3];     // Precharge Command
    reg                           A10_precharge        [0 : 3];     // Addr[10] = 1 (All banks)
    reg                           Auto_precharge       [0 : 3];     // RW Auto Precharge (Bank)
    reg                           Read_precharge       [0 : 3];     // R  Auto Precharge
    reg                           Write_precharge      [0 : 3];     //  W Auto Precharge
    reg                           RW_interrupt_read    [0 : 3];     // RW Interrupt Read with Auto Precharge
    reg                           RW_interrupt_write   [0 : 3];     // RW Interrupt Write with Auto Precharge
    reg                   [1 : 0] RW_interrupt_bank;                // RW Interrupt Bank
    integer                       RW_interrupt_counter [0 : 3];     // RW Interrupt Counter
    integer                       Count_precharge      [0 : 3];     // RW Auto Precharge Counter

    reg                           Data_in_enable;
    reg                           Data_out_enable;

    reg                   [1 : 0] Bank, Prev_bank;
    reg       [addr_bits - 1 : 0] Row;
    reg        [col_bits - 1 : 0] Col, Col_brst;

    // Internal system clock
    reg                           CkeZ, Sys_clk;

    // Commands Decode
    wire      Active_enable    = ~Cs_n & ~Ras_n &  Cas_n &  We_n;
    wire      Aref_enable      = ~Cs_n & ~Ras_n & ~Cas_n &  We_n;
    wire      Burst_term       = ~Cs_n &  Ras_n &  Cas_n & ~We_n;
    wire      Mode_reg_enable  = ~Cs_n & ~Ras_n & ~Cas_n & ~We_n;
    wire      Prech_enable     = ~Cs_n & ~Ras_n &  Cas_n & ~We_n;
    wire      Read_enable      = ~Cs_n &  Ras_n & ~Cas_n &  We_n;
    wire      Write_enable     = ~Cs_n &  Ras_n & ~Cas_n & ~We_n;

    // Burst Length Decode
    wire      Burst_length_1   = ~Mode_reg[2] & ~Mode_reg[1] & ~Mode_reg[0];
    wire      Burst_length_2   = ~Mode_reg[2] & ~Mode_reg[1] &  Mode_reg[0];
    wire      Burst_length_4   = ~Mode_reg[2] &  Mode_reg[1] & ~Mode_reg[0];
    wire      Burst_length_8   = ~Mode_reg[2] &  Mode_reg[1] &  Mode_reg[0];
    wire      Burst_length_f   =  Mode_reg[2] &  Mode_reg[1] &  Mode_reg[0];

    // CAS Latency Decode
    wire      Cas_latency_2    = ~Mode_reg[6] &  Mode_reg[5] & ~Mode_reg[4];
    wire      Cas_latency_3    = ~Mode_reg[6] &  Mode_reg[5] &  Mode_reg[4];

    // Write Burst Mode
    wire      Write_burst_mode = Mode_reg[9];

    wire      Debug            = 1'b1;                          // Debug messages : 1 = On
    wire      Dq_chk           = Sys_clk & Data_in_enable;      // Check setup/hold time for DQ
    
    assign    Dq               = Dq_reg;                        // DQ buffer

    // Commands Operation
    `define   ACT       0
    `define   NOP       1
    `define   READ      2
    `define   WRITE     3
    `define   PRECH     4
    `define   A_REF     5
    `define   BST       6
    `define   LMR       7

    // Timing Parameters for -7E PC133 CL2
    parameter tAC  =   5.4;
    parameter tHZ  =   5.4;
    parameter tOH  =   3.0;
    parameter tMRD =   2.0;     // 2 Clk Cycles
    parameter tRAS =  37.0;
    parameter tRC  =  60.0;
    parameter tRCD =  15.0;
    parameter tRFC =  66.0;
    parameter tRP  =  15.0;
    parameter tRRD =  14.0;
    parameter tWRa =   7.0;     // A2 Version - Auto precharge mode (1 Clk + 7 ns)
    parameter tWRm =  14.0;     // A2 Version - Manual precharge mode (14 ns)

    endspecify

endmodule
