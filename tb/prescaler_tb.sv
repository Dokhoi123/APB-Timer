module prescaler_tb;
  logic clk, rst_n;
  logic [1:0] clk_s;
  logic clk_out;

  prescaler dut (clk, rst_n, clk_s, clk_out);

  initial begin
    rst_n = 1'b0;
    #20ns;
    rst_n = 1'b1;
    #10us;
    $display("End simulation");
    $finish();
  end

  initial begin
    clk = 1'b1;
    forever #10ns clk = ~clk;
  end

  initial begin
    clk_s = 2'b00;
    #50ns;
    clk_s = 2'b01;
    #100ns;
    clk_s = 2'b10;
    #200ns;
  end

endmodule
