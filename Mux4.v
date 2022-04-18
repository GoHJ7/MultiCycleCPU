module Mux4(signal, 
sig3,
sig2,
sig1, 
sig0, 
out
);
input [1:0]signal;
input [31:0] sig1, sig0, sig2, sig3;
output [31:0] out;

assign out = signal[1] ? (signal[0] ? sig3 : sig2)
                        : (signal[0] ? sig1 : sig0);

endmodule
