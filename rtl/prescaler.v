module prescaler(
  input clk, rst_n,
  input [1:0] clk_s,
  output reg clk_out
);

  reg [5:0] counter;
  reg [5:0] divisor;
  
  always@(*) begin
    case(clk_s)
      2'b00: divisor = 2;
      2'b01: divisor = 4;
      2'b10: divisor = 8;
      2'b11: divisor = 16;
      default: divisor = 2;
    endcase
  end


  always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      counter <= 0;
      clk_out <= 1'b0;
    end
    else begin
      counter <= counter + 28'd1;
      if(counter>=(divisor-1)) counter <= 28'd0;
      clk_out <= (counter<divisor/2)?1'b1:1'b0;
    end
  end

endmodule
