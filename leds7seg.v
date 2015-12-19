/******************************************************************

  Helsinki Hacklab - Protoboard for digital electronics workshops
    
  Show led pattern as two hex digits on 7-segment display.
  
  For CPLD 2.
  
  XC9572XL-VQ44
  
******************************************************************/

module leds7seg(
    input wire fastclk,
    input wire [7:0] led,           // leds used as inputs
    output reg [7:0] seg,
    output wire io_select,
    output wire led_R, led_G, led_B
    );

    // --- Display multiplexing signal ---------------------------------
    
    // 16-bit counter: 25 MHz / 2^16 = 381 Hz
    reg [15:0] muxdiv = 0;
    wire mux;

    assign mux = muxdiv[15];
    
    always @(posedge fastclk) begin
        muxdiv <= muxdiv + 1; 
    end

    // --- 7-segment decoder ----------------------------------------
    wire [3:0] bin;
    
    // Decode 4-bit binary number in bin to segment pattern
    always @(*) begin
        case(bin)
             //             Pabcdefg
             4'h0: seg = 8'b01111110;
             4'h1: seg = 8'b00110000;
             4'h2: seg = 8'b01101101;
             4'h3: seg = 8'b01111001;
             4'h4: seg = 8'b00110011;
             4'h5: seg = 8'b01011011;
             4'h6: seg = 8'b01011111;
             4'h7: seg = 8'b01110000;
             4'h8: seg = 8'b01111111;
             4'h9: seg = 8'b01111011;
             4'hA: seg = 8'b01110111;
             4'hB: seg = 8'b00011111;
             4'hC: seg = 8'b01001110;
             4'hD: seg = 8'b00111101;
             4'hE: seg = 8'b01001111;
             4'hF: seg = 8'b01000111;
             default: seg = 8'b00000000;
        endcase
    end

    // --- Multiplexer --------------------------------------------------
    
    // Assign high or low nibble of leds to bin
    // mux=0 -> high nibble, mux=1 -> low nibble
    assign bin = mux ? led[3:0] : led[7:4];
    
    // set I/O select according to mux
    // mux=0 -> left side, mux=1 -> right side
    assign io_select = mux;
    
    // --- Turn off the ultrabright RGB-led! ------------------------------
    assign led_R = 0;
    assign led_G = 0;
    assign led_B = 0;

endmodule
