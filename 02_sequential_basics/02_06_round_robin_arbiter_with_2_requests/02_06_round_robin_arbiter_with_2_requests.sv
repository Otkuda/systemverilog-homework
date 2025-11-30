//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module round_robin_arbiter_with_2_requests
(
    input        clk,
    input        rst,
    input  [1:0] requests,
    output [1:0] grants
);
    // Task:
    // Implement a "arbiter" module that accepts up to two requests
    // and grants one of them to operate in a round-robin manner.
    //
    // The module should maintain an internal register
    // to keep track of which requester is next in line for a grant.
    //
    // Note:
    // Check the waveform diagram in the README for better understanding.
    //
    // Example:
    // requests -> 01 00 10 11 11 00 11 00 11 11
    // grants   -> 01 00 10 01 10 00 01 00 10 01

logic next;

always_ff @(posedge clk) begin
  if (rst) begin
    next <= '0;
  end
  else begin
    if (grants != '0) begin
      next <= ~grants[1];
    end
  end
end

assign grants[0] = requests[0] & (~next | ~(requests[0] & requests[1]));
assign grants[1] = requests[1] & ( next | ~(requests[0] & requests[1]));

endmodule
