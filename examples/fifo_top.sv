module fifo_top (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        wr_en,
    input  logic [15:0] wr_data,
    input  logic        rd_en,
    output logic [15:0] rd_data,
    output logic        full,
    output logic        empty
);
    sync_fifo #(
        .DATA_WIDTH(16),
        .DEPTH(16)
    ) u_fifo (
        .clk,
        .rst_n,
        .wr_en,
        .wr_data,
        .rd_en,
        .rd_data,
        .full,
        .empty
    );
endmodule
