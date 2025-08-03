module apb_slave_tb;
  logic pclk, preset_n, pwrite, psel, penable;
  logic [7:0] paddr, pwdata, prdata;
  logic pready, pslverr;
  logic over, under, updown;
  logic [1:0] clk_s;
  logic en, inter_en, init_cnt;
  logic [7:0] timer_val;


  apb_slave dut (pclk, preset_n, psel, penable, pwrite, paddr, pwdata, prdata, pready, pslverr, over, under, updown, clk_s, en, inter_en, init_cnt, timer_val);

  initial begin
    preset_n = 1'b0;
    #20ns;
    preset_n = 1'b1;
    #2us;
    $display("End simulation");
    $finish();
  end

  initial begin
    pclk = 1'b1;
    forever #10ns pclk = ~pclk;
  end
  
  initial begin
    wait(!preset_n);
    pwrite = 1'b0;
    psel = 1'b0;
    penable = 1'b0;
    over <= 1'b0;
    under <= 1'b0;
    write(8'h02, 8'h64); 
    write(8'h00, 8'b10000000);
    write(8'h00, 8'b00111000);
    
    read(8'h02);

  end


  
  task write(logic [7:0] addr, logic [7:0] data);
    @(posedge pclk);
    paddr = addr;
    psel = 1'b1;
    pwrite = 1'b1;
    pwdata = data;
    $display("%t Write %0h to addr: %0h", $time, pwdata, paddr);
    @(posedge pclk);
    penable = 1'b1;
    wait(pready);
    if(pslverr) $display("%t: Write failed", $time);
    else        $display("%t: Write success", $time);
    psel = 1'b0;
    pwrite = 1'b0;
    penable = 1'b0;
  endtask

  task read(logic [7:0] addr);
    @(posedge pclk);
    paddr = addr;
    psel = 1'b1;
    pwrite = 1'b0;
    $display("%t Read data fromm addr %0h", $time, paddr);
    @(posedge pclk);
    penable= 1'b1; 
    wait(pready);
    if(pslverr) $display("%t: Data not valid", $time);
    else        $display("%t: Data valid: %0h", $time, prdata);
    psel = 1'b0;
    penable = 1'b0;
  endtask

endmodule
