module top
  (
   input [63:0]       x,

   output wire        badness,  // not expected to evaluate to TRUE, but does
   output wire        goodness
   );

   // In all verilator versions I tried (5.012, 5.020, 5.024, 5.026),
   // the "bad" expressions below evaluate to TRUE. That is not what I expect.
   wire bad    = {x[38:32], x[38] ^ x[31] ^ x[38]} != x[38:31];
   assign badness = bad;

   // All of the below expressions behave as expected (evaluate to FALSE, always)
   wire good_1 = {x[38:32], 1'b0  ^ x[31] ^ 1'b0 } != x[38:31];
   wire good_2 = {x[38:32], 1'b1  ^ x[31] ^ 1'b1 } != x[38:31];
   wire good_3 = {x[38:32], x[31] ^ x[38] ^ x[38]} != x[38:31];
   wire good_4 = {x[38:33], x[32] ^ x[38] ^ x[38]} != x[38:32];
   assign goodness = good_1 | good_2 | good_3 | good_4;

   wire xor3_ok  = x[38] ^ x[32] ^ x[38];
   // Enabling the line gives me a zero-length waveform ??
   wire xor3_huh = 1'b0;
   //wire xor3_huh = x[38] ^ x[31] ^ x[38];

   // Enabling any of the commented lines makes the problem magically go away
   //wire problem_goes_away_1 = x[38:31] != {x[38:32], x[38] ^ x[31] ^ x[38]};
   //wire problem_goes_away_2 = {x[38:32], x[38] ^ x[38] ^ x[31]} != x[38:31];
   //wire [38:31] problem_goes_away_3 = {x[38:32], x[38] ^ x[31] ^ x[38]};
   //wire problem_goes_away_4 =            x[38] ^ x[31] ^ x[38] != x[31];
   wire [38:31] right = {x[38:31]};
   wire unused = &x | &right & xor3_ok & xor3_huh;


   // Print some stuff as an example
   initial begin
      if ($test$plusargs("trace") != 0) begin
         $display("[%0t] Tracing to logs/vlt_dump.vcd...\n", $time);
         $dumpfile("logs/vlt_dump.vcd");
         $dumpvars();
      end
      $display("[%0t] Model running...\n", $time);
   end

endmodule
