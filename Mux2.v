module Mux2(signal, 
sig1, 
sig0, 
out
);
input signal;
input [31:0] sig1, sig0;
output [31:0] out;

assign out = (signal)? sig1 : sig0 ;

endmodule
