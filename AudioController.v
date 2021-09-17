module AudioController(
    input        clk, 		// System Clock Input 100 Mhz
    input [3:0]  switches,	// Tone control switches
	input 		 crash_en,	// Turn on when crash
    output       chSel,		// Channel select; 0 for rising edge, 1 for falling edge
    output       audioOut,	// PWM signal to the audio jack	
    output       audioEn);	// Audio Enable

	localparam MHz = 1000000;
	localparam SYSTEM_FREQ = 100*MHz; // System clock frequency

	assign chSel   = 1'b0;  // Collect Mic Data on the rising edge 
	assign audioEn = crash_en;  // Enable Audio Output

	// Initialize the frequency array. FREQs[0] = 261
	reg[10:0] FREQs[0:15];
	initial begin
		$readmemh("FREQs.mem", FREQs);
	end
	
	////////////////////
	// Your Code Here //
	////////////////////

	wire[31:0] counterLimit;
	
	//Index into sound array
	wire [3:0] audioConcat;
	assign audioConcat[3:1] = switches[3:1];
	assign audioConcat[0] = crash_en;
  	assign counterLimit = (SYSTEM_FREQ/(2*FREQs[audioConcat])) - 1;

  	reg nclk = 0;
  	reg[31:0] counter = 0;

	always @(posedge clk) begin
		if(counter < counterLimit)
		counter <= counter + 1;
		else begin 
		counter <= 0;
		nclk <= ~ nclk;
		end
	end

	wire[6:0] duty_cycle;
	wire[6:0] max = 7'b1100011;
	wire[6:0] min = 7'b0000000;

	assign duty_cycle = nclk ? max : min;

	PWMSerializer ser(clk, reset, duty_cycle, audioOut);
  
endmodule
