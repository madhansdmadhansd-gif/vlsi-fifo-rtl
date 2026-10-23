module sync_fifo #(
    parameter int unsigned DATA_WIDTH = 8,
    parameter int unsigned DEPTH = 16,
    localparam int unsigned PTR_WIDTH = (DEPTH <= 1) ? 1 : $clog2(DEPTH),
    localparam int unsigned COUNT_WIDTH = $clog2(DEPTH + 1)
) (
    input  logic                  clk,
    input  logic                  rst_n,
    input  logic                  wr_en,
    input  logic [DATA_WIDTH-1:0] wr_data,
    input  logic                  rd_en,
    output logic [DATA_WIDTH-1:0] rd_data,
    output logic                  full,
    output logic                  empty
);

    logic [DATA_WIDTH-1:0] storage [0:DEPTH-1];
    logic [PTR_WIDTH-1:0] wr_ptr;
    logic [PTR_WIDTH-1:0] rd_ptr;
    logic [COUNT_WIDTH-1:0] count;
    logic accept_read;
    logic accept_write;

    initial begin
        if (DATA_WIDTH == 0) $error("DATA_WIDTH must be positive");
        if (DEPTH == 0) $error("DEPTH must be positive");
    end

    assign full = (count == DEPTH);
    assign empty = (count == 0);
    assign rd_data = storage[rd_ptr];

    assign accept_read = rd_en && !empty;
    // Allow replacement of the entry read in the same cycle when full.
    assign accept_write = wr_en && (!full || accept_read);

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_ptr <= '0;
            rd_ptr <= '0;
            count  <= '0;
        end else begin
            if (accept_write) begin
                storage[wr_ptr] <= wr_data;
                if (wr_ptr == DEPTH - 1)
                    wr_ptr <= '0;
                else
                    wr_ptr <= wr_ptr + 1'b1;
            end

            if (accept_read) begin
                if (rd_ptr == DEPTH - 1)
                    rd_ptr <= '0;
                else
                    rd_ptr <= rd_ptr + 1'b1;
            end

            case ({accept_write, accept_read})
                2'b10: count <= count + 1'b1;
                2'b01: count <= count - 1'b1;
                default: count <= count;
            endcase
        end
    end
endmodule
