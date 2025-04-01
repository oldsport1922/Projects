import taillights_pkg::*;

module fsm (
    input logic clk,
    input logic rst_n,
    input logic left_i,
    input logic right_i,
    input logic hazard_i,
    output state_t state_o,
    output logic [5:0] pattern_o
);


    state_t state_d, state_q = S000_000;

    assign state_o = state_q;

    always_comb begin
        state_d = state_q; // Default next state

        case (state_q)
            S000_000: begin
              if (!left_i & !right_i & !hazard_i) begin
                state_d = S000_000;
              end else if ((left_i & right_i) | hazard_i) begin
                state_d = S111_111;
              end else if (!left_i & right_i & !hazard_i) begin
                state_d = S000_100;
              end else if (left_i & !right_i & !hazard_i) begin
                state_d = S001_000;
              end
            end
            S000_100: begin
              if (!right_i) begin
                state_d = S000_000;
              end else if ((left_i & right_i) | hazard_i) begin
                state_d = S111_111;
              end else if (!left_i & right_i & !hazard_i) begin
                state_d = S000_110;
              end
            end
            S000_110: begin
              if (!right_i) begin
                state_d = S000_000;
              end else if ((left_i & right_i) | hazard_i) begin
                state_d = S111_111;
              end else if (!left_i & right_i & !hazard_i) begin
                state_d = S000_111;
              end
            end
            S000_111: begin
              if (!right_i) begin
                state_d = S000_000;
              end else if ((left_i & right_i) | hazard_i) begin
                state_d = S111_111;
              end else if (!left_i & right_i & !hazard_i) begin
                state_d = S000_000;
              end
            end
            S001_000: begin
              if (!left_i) begin
                state_d = S000_000;
              end else if ((left_i & right_i) | hazard_i) begin
                state_d = S111_111;
              end else if (left_i & !right_i & !hazard_i) begin
                state_d = S011_000;
              end
            end
            S011_000: begin
              if (!left_i) begin
                state_d = S000_000;
              end else if ((left_i & right_i) | hazard_i) begin
                state_d = S111_111;
              end else if (left_i & !right_i & !hazard_i) begin
                state_d = S111_000;
              end
            end
            S111_000: begin
              if (!left_i) begin
                state_d = S000_000;
              end else if ((left_i & right_i) | hazard_i) begin
                state_d = S111_111;
              end else if (left_i & !right_i & !hazard_i) begin
                state_d = S000_000;
              end
            end
            S111_111: begin
              if (!left_i & !right_i & !hazard_i) begin
                state_d = S000_000;
              end else if ((left_i & right_i) | hazard_i) begin
                state_d = S000_000;
              end else if (!left_i & right_i & !hazard_i) begin
                state_d = S000_100;
              end else if (left_i & !right_i & !hazard_i) begin
                state_d = S001_000;
              end
            end
            default: state_d = S000_000;
        endcase
    end

    always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
        state_q <= S000_000;
      end
      	else begin state_q <= state_d;
      end
    end
  
    always_comb begin
        case (state_q)
            S000_000: pattern_o = 6'b000000;
            S000_100: pattern_o = 6'b000100;
            S000_110: pattern_o = 6'b000110;
            S000_111: pattern_o = 6'b000111;
            S001_000: pattern_o = 6'b001000;
            S011_000: pattern_o = 6'b011000;
            S111_000: pattern_o = 6'b111000;
            S111_111: pattern_o = 6'b111111;
            default:  pattern_o = 6'b000000;
        endcase
    end

endmodule

