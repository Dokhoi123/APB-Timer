module timer(
  input clk, updown, rst_n, en, init_cnt,
  input [7:0] data_in,
  output reg over, under
);
  
  reg [7:0] counter, counter_set;

  always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      counter <= 0;
      over <= 1'b0;
      under <= 1'b0;
    end 
    else if (init_cnt) begin
      counter <= data_in;
      counter_set <= data_in;
      over <= 1'b0;
      under <= 1'b0;
    end
    else begin
      if(en) begin
        if(updown) begin
          if(counter == 8'hff) begin
            counter <= counter_set;
            over <= 1'b1;
            under <= 1'b0;
          end
          else begin
            counter <= counter + 1;
            over <= 1'b0;
            under <= 1'b0;
          end
        end
        else begin
          if(counter == 8'h00) begin
            counter <= counter_set;
            under <= 1'b1;
            over <= 1'b0;
          end
          else begin
            counter <= counter -1;
            under <= 1'b0;
            over <= 1'b0;
          end
        end
      end
      else counter <= counter;
    end
  end

  endmodule    



