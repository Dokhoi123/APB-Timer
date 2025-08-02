module apb_slave (
  ///// APB INTERFACE /////
  input pclk, preset_n, psel, penable, pwrite,
  input [7:0] paddr, pwdata,
  output reg [7:0] prdata,
  output reg pready,
  output reg pslverr,
  ///// TIMER INTERFACE /////
  input over, under,
  output reg updown,
  output reg [1:0] clk_s,
  output reg en,
  output reg inter_en, init_cnt,
  output reg [7:0] timer_val
);

  reg [7:0] mem_reg [2:0];
  reg load;

  always@(posedge pclk or negedge preset_n) begin

    if(!preset_n) begin
      prdata  <= 0;
      pready  <= 1'b0;
      pslverr <= 1'b0;
    end
    else begin
      ///// WRITE TRANFER ////
      if(psel&penable&pwrite) begin
        if(paddr>2) begin
          pready  <= 1'b1;
          pslverr <= 1'b1;
        end
        else begin
          mem_reg[paddr] <= pwdata;
          pready  <= 1'b1;
          pslverr <= 1'b0;
        end
      end
      ///// READ TRANFER ////
      else if(psel&penable&!pwrite) begin
        if(paddr>2) begin
          pready  <= 1'b1;
          pslverr <= 1'b1;
        end
        else begin
          prdata  <= mem_reg[paddr];
          pready  <= 1'b1;
          pslverr <= 1'b0;
        end
      end
      //// DEFAULT ////
      else begin
        prdata  <= 0;
        pready  <= 1'b0;
        pslverr <= 1'b0;
      end
    end
  end
  ///// TCR /////
  always@(posedge pclk or negedge preset_n) begin
    if(!preset_n)begin
      mem_reg[0] <= 0;
    end
    else begin
      clk_s    <= mem_reg[0] [1:0];
      inter_en <= mem_reg[0] [3];
      en       <= mem_reg[0] [4];
      updown   <= mem_reg[0] [5];
      load     <= mem_reg[0] [7];
    end
  end
  ///// TSR /////
  always@(posedge pclk or negedge preset_n) begin
    if(!preset_n) begin
      mem_reg[1] <= 0;
    end
    else begin
      if(over) mem_reg[1] [0] <= 1'b1;
      else if(under) mem_reg[1] [1] <= 1'b1;
    end
  end
  ///// TDR /////
  always@(posedge pclk or negedge preset_n) begin
    if(!preset_n) begin
      mem_reg[2] <= 0;
    end
    else begin
      if(load == 1'b1) begin
        init_cnt  <= 1'b1;
        timer_val <= mem_reg[2];
      end
      else begin
        init_cnt <= 1'b0;  
        timer_val <= 0;
      end
    end
  end

endmodule

