module Muxecall(signal, 
sig1, 
sig0, 
out
);
input signal;
input [4:0] sig1, sig0;
output [4:0] out;

assign out = (signal)? sig1 : sig0 ;

endmodule
