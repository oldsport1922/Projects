
module ucsbece152a_taillights (
    input logic clk,
    input logic rst_n,
    input logic clk_dimmer_i,
    input logic left_i,
    input logic right_i,
    input logic hazard_i,
    input logic brake_i,
    input logic runlights_i,
    output logic [5:0] lights_o
);

    logic [5:0] fsm_pattern;
    logic [5:0] lights_runlightsoff, lights_runlightson;

    ucsbece152a_fsm fsm (
        .clk(clk),
        .rst_n(rst_n),
        .left_i(left_i),
        .right_i(right_i),
        .hazard_i(hazard_i),
        .pattern_o(fsm_pattern)
    );

  
  	logic [5:0] fsm_brake;
  	always_comb begin
      if(brake_i) begin
        case (fsm_pattern)
            6'b000000: begin
              if(left_i & !right_i & !hazard_i) begin
             	 fsm_brake = 6'b000111;
              end else if(!left_i & right_i & !hazard_i) begin
             	 fsm_brake = 6'b111000;
              end else begin
                 fsm_brake = 6'b111111;
              end
            end
            6'b000100: fsm_brake = 6'b111100;
            6'b000110: fsm_brake = 6'b111110;
            6'b000111: fsm_brake = 6'b111111;
            6'b001000: fsm_brake = 6'b001111;
            6'b011000: fsm_brake = 6'b011111;
            6'b111000: fsm_brake = 6'b111111;
            6'b111111: fsm_brake = 6'b111111;
            default: fsm_brake = 6'b111111;
        endcase
      end else begin
        fsm_brake = fsm_pattern;
      end
    end

  
    integer i;
    always_comb begin
        lights_runlightsoff = fsm_brake;
      
      	for (i = 0; i < 6; i++) begin
          lights_runlightson[i] = (fsm_brake[i]) ? 1'b1 : clk_dimmer_i;
	   	end

        lights_o = (runlights_i) ? lights_runlightson : lights_runlightsoff;
    end

endmodule
