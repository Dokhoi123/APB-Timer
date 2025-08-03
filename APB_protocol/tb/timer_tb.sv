module timer_tb;
  logic clk, updown, rst_n, en, init_cnt;
  logic [7:0] data_in;
  logic over, under;

  timer dut (clk, updown, rst_n, en, init_cnt, data_in, over, under);

  initial begin
    #1ns;
    rst_n = 1'b0;
    #20ns;
    rst_n = 1'b1;
    #10us;
    $display("End simulation");
    $finish();
  end
  
  initial begin
    wait(rst_n);
    @(posedge clk);
    data_in = 100;
    init_cnt = 1'b1;
    updown = 1'b1;
    @(posedge clk);
    init_cnt = 1'b0;
    wait(over);
    $display("%0t: Overflow", $time);
    @(posedge clk);
    updown <= 1'b0;
    data_in <= 20;
    wait(under);
    $display("%0t: Underflow", $time);

  end
  
  initial begin
    clk = 1'b1;
    en = 1'b1;
    fork
    forever #10ns clk = ~clk;
    forever #20ns en = ~en;
    join

  end

endmodule

