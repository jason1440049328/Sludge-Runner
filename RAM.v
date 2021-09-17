`timescale 1ns / 1ps
module RAM #( parameter DATA_WIDTH = 32, ADDRESS_WIDTH = 12, DEPTH = 4096, MEMFILE = "C:/Users/Jason Dong/Desktop/team-a-2737/dmem.mem") (
    input wire                     clk,
    input wire                     wEn,
    input wire [ADDRESS_WIDTH-1:0] addr,
    input wire [DATA_WIDTH-1:0]    dataIn,
    output reg [DATA_WIDTH-1:0]    dataOut = 0);
    
    reg[DATA_WIDTH-1:0] MemoryArray[0:DEPTH-1];
    wire clock;
    assign clock = ~clk;

    initial begin
        if(MEMFILE > 0) begin
            $readmemh(MEMFILE, MemoryArray);
        end
    end
    
    always @(posedge clock) begin
        if(wEn) begin
            MemoryArray[addr] <= dataIn;
        end else begin
            dataOut <= MemoryArray[addr];
        end
    end
endmodule
