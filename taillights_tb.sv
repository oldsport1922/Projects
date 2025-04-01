
module taillights_tb();

// Create clock signal
logic clk = 0;
always #(10) clk = ~clk; // flip `clk` every 10 timesteps
logic clk_dimmer_i = 0;
always #(2) clk_dimmer_i = ~clk_dimmer_i; //create dimmer signal, not same frequency

// Instantiate nets
logic rst_n;
logic left_i;
logic right_i;
logic hazard_i;
logic brake_i;
logic runlights_i;
logic [5:0] lights_o;

// Instantiate the "Design Under Test"
ucsbece152a_taillights #(
) DUT (
	.clk(clk),
	.rst_n(rst_n),
	.clk_dimmer_i(clk_dimmer_i),
	.left_i(left_i),
	.right_i(right_i),
	.hazard_i(hazard_i),
	.brake_i(brake_i),
	.runlights_i(runlights_i),
	.lights_o(lights_o)
);

// Simulation
integer i;
initial begin
$display( "Begin simulation.");
rst_n = 0;
left_i = 0;
right_i = 0;
hazard_i = 0;
brake_i = 0;
runlights_i = 0;

@(negedge clk);
rst_n = 1; //start running
@(negedge clk);
left_i = 1; //test left
@(negedge clk);
@(negedge clk);
@(negedge clk);
@(negedge clk);
left_i = 0;
right_i = 1; //test right
@(negedge clk);
@(negedge clk);
left_i = 1; //test both for hazard
@(negedge clk);
@(negedge clk);
left_i = 0;
hazard_i = 1; //test hazard overwrite
@(negedge clk);
right_i = 0; //test just hazard
@(negedge clk);
brake_i = 1; //test brake overwrite
@(negedge clk);
@(negedge clk);
hazard_i = 0;
left_i = 1; //test brake and left
@(negedge clk);
@(negedge clk);
@(negedge clk);
@(negedge clk);
brake_i = 0;
runlights_i = 1; //test runlights
@(negedge clk);
@(negedge clk);
runlights_i = 0;
@(negedge clk);

$display( "End simulation.");
end
endmodule