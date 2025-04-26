module two_wire_i2c(
    input wire clk,
    input wire reset,
    input wire start,
    input wire [7:0] data_in,
    output reg scl,
    inout wire sda
    );

    // Internal signals
    reg [1:0] state;          // State variable for the state machine
    reg [7:0] shift_reg;      // Shift register to hold data
    reg [2:0] bit_count;      // Counter for the number of bits
    reg sda_out;              // Internal signal to drive `sda`

    // Tri-state logic for `sda`
    assign sda = (state == 2) ? sda_out : 1'bz; // Drive `sda` only during data transmission

    // State Machine
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 0;
            scl <= 1;
            shift_reg <= 0;
            bit_count <= 0;
            sda_out <= 1; // Default high state for `sda`
        end else begin
            case (state)
                // Idle state
                0: begin
                    if (start) begin
                        state <= 1;
                        shift_reg <= data_in;
                        bit_count <= 7;
                    end
                end
                // Start condition
                1: begin 
                    scl <= 0; // Pull SCL low
                    state <= 2;
                end
                // Data transmission state
                2: begin
                    sda_out <= shift_reg[bit_count]; // Send MSB first
                    scl <= 1; // Clock high
                    if (bit_count == 0)
                        state <= 3; // Move to stop condition
                    else
                        bit_count <= bit_count - 1; // Decrement bit counter
                end
                // Stop condition
                3: begin
                    scl <= 0; // Pull SCL low
                    state <= 0; // Return to idle
                end
            endcase
        end
    end
endmodule

