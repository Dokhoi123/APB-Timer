module apb_timer(
  input pclk, preset_n, psel, penable, pwrite,
  input [7:0] paddr, pwdata,
  output  [7:0] prdata,
  output pready,
  output pslverr,
  output interrupt
);
  
  wire clk_out, updown, over, under, clk, inter_en, en, init_cnt;
  wire [1:0] clk_s;
  wire [7:0] time_val;

  assign clk = pclk&en;
  assign interrupt = inter_en&(over|under);
  prescaler pre (.clk(clk),
                 .rst_n(preset_n),
                 .clk_s(clk_s),
                 .clk_out(clk_out)
                );
  
  timer ti (.clk(pclk),
            .init_cnt(init_cnt),
            .en(clk_out),
            .updown(updown),
            .data_in(time_val),
            .over(over),
            .under(under),
            .rst_n(preset_n) 	
           );
  
  apb_slave apb (.pclk(pclk),
                 .preset_n(preset_n),
                 .psel(psel),
                 .penable(penable),
                 .pwrite(pwrite),
                 .paddr(paddr),
                 .pwdata(pwdata),
                 .prdata(prdata),
                 .pready(pready),
                 .pslverr(pslverr),
                 .over(over),
                 .under(under),
                 .updown(updown),
                 .clk_s(clk_s),
                 .en(en),
                 .init_cnt(init_cnt),
                 .inter_en(inter_en),
                 .timer_val(time_val)
                );
endmodule
