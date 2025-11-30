//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module parallel_to_serial
# (
    parameter width = 8
)
(
    input                      clk,
    input                      rst,

    input                      parallel_valid,
    input        [width - 1:0] parallel_data,

    output                     busy,
    output logic               serial_valid,
    output logic               serial_data
);
    // Task:
    // Implement a module that converts multi-bit parallel value to the single-bit serial data.
    //
    // The module should accept 'width' bit input parallel data when 'parallel_valid' input is asserted.
    // At the same clock cycle as 'parallel_valid' is asserted, the module should output
    // the least significant bit of the input data. In the following clock cycles the module
    // should output all the remaining bits of the parallel_data.
    // Together with providing correct 'serial_data' value, module should also assert the 'serial_valid' output.
    //
    // Note:
    // Check the waveform diagram in the README for better understanding.

logic [width-1:0] data;
logic [$clog2(width)-1:0] cnt;

always_ff @(posedge clk) begin
  if (rst) begin
    data <= '0;
    cnt  <= '0;
  end
  else begin
    if (parallel_valid && cnt == '0) begin
      data <= parallel_data;
      cnt <= 1;
    end
    else if (cnt != '0) begin
      cnt <= cnt + 1;
      if (cnt == width - 1) begin
        cnt <= '0;
        data <= '0;
      end
    end
  end
end

assign serial_data = parallel_valid ? parallel_data[0] : data[cnt];
assign serial_valid = parallel_valid | busy;
assign busy = cnt > 0;

endmodule
