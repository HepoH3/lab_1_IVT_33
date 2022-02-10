module testbench();

    logic [127:0] data_to_cipher [11];
    logic [127:0] ciphered_data  [11];
    logic clk, resetn, request, ack, valid, busy;
    logic [127:0] data_i, data_o;

    initial clk <= 0;

    always #5ns clk <= ~clk;

    integer i = 0;
    logic [128*11-1:0] print_str;


    kuznechik_cipher DUT(
        .clk_i      (clk),
        .resetn_i   (resetn),
        .data_i     (data_i),
        .request_i  (request),
        .ack_i      (ack),
        .data_o     (data_o),
        .valid_o    (valid),
        .busy_o     (busy)
    );

    initial begin
        data_to_cipher[00] <= 128'h69b7dcb452e20d03a7008f242b0276b5;
        data_to_cipher[01] <= 128'h44b09c33dcba740f7bfb246e6782b505;
        data_to_cipher[02] <= 128'h3e2c47c3841a82faf53bd0789ca2a6a3;
        data_to_cipher[03] <= 128'hd8234eb3f9d07a8740a48dada17b8239;
        data_to_cipher[04] <= 128'h009da783cee6c40566a16bd87bce059b;
        data_to_cipher[05] <= 128'hd049ba2cd4d32933ef30090cd63dcf59;
        data_to_cipher[06] <= 128'h35535e9063c77766f5d97011678c5006;
        data_to_cipher[07] <= 128'h865cfa2fbbe67d9d68c34b2a243741a9;
        data_to_cipher[08] <= 128'h0ff840ab07fbe67ece4efe44c1fae2aa;
        data_to_cipher[09] <= 128'he9ed97e8c597dac46c70a361bdd34242;
        data_to_cipher[10] <= 128'h3a9e8de9d07a6c29c25424c48ef5ce52;
        $display("Testbench has been started.\nResetting");
        resetn <= 1'b0;
        ack <= 0;
        request <= 0;
        repeat(2) begin
            @(posedge clk);
        end
        resetn <= 1'b1;
        for(i=0; i < 11; i++) begin
            $display("Trying to cipher %d chunk of data", i);
            @(posedge clk);
            data_i <= data_to_cipher[i];
            while(busy) begin
                @(posedge clk);
            end
            request <= 1'b1;
            @(posedge clk);
            request <= 1'b0;
            while(~valid) begin
                @(posedge clk);
            end
            ciphered_data[i] <= data_o;
            ack <= 1'b1;
            @(posedge clk);
            ack <= 1'b0;
        end
        $display("Ciphering has been finished.");
        $display("============================");
        $display("===== Ciphered message =====");
        $display("============================");
        print_str = {ciphered_data[0],
                        ciphered_data[1],
                        ciphered_data[2],
                        ciphered_data[3],
                        ciphered_data[4],
                        ciphered_data[5],
                        ciphered_data[6],
                        ciphered_data[7],
                        ciphered_data[8],
                        ciphered_data[9],
                        ciphered_data[10]
                    };
        $display("%s", print_str);
        $display("============================");
        $finish();
    end

endmodule
