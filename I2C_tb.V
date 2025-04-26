module two_wire_i2c_tb;
    reg clk;
    reg reset;
    reg start;
    reg [7:0]data_in;
    wire scl;
    wire sda;
    //Initiate the what is logic 0 is -1.1 and the logic 1 is -0.8 can u represent it i both the positive and negative

    two_wire_i2c uut(
        .clk(clk),
        .reset(reset),
        .start(start),
        .data_in(data_in),
        .scl(scl),
        .sda(sda)
    );
    //Clock Generation
    initial begin
        clk=0;
        forever #5 clk=~clk;
    end
    //Test Sequence
    initial begin
        reset=1;
        start=0;
        data_in=8'b10101010;
        #10 reset =0;
        #20 start =1;
        #10 start =0;
        #100 $stop;
    end
endmodule
