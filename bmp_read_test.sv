module bmp_read_test;
    parameter WIDTH  = 256;  // 画像の幅
    parameter HEIGHT = 256;  // 画像の高さ
    parameter HEADER_SIZE = 54 + 1024; // BMP ヘッダのサイズ

    logic [7:0] memory [0:HEIGHT-1][0:WIDTH-1]; // 画像データ用メモリ

    // BMP を直接読み込んでメモリに展開するタスク
    task automatic load_bmp(string filename);
        integer file, i;
        integer row, col;
        logic [7:0] temp;

        file = $fopen(filename, "rb"); // BMP をバイナリモードで開く
        if (file == 0) begin
            $display("Error: Cannot open file %s", filename);
            $finish;
        end

        // ヘッダの 54 バイトを読み飛ばす
        for (i = 0; i < HEADER_SIZE; i++) begin
            void'($fgetc(file));
        end

        // ピクセルデータを読み込み、上下反転してメモリに格納
        for (i = 0; i < WIDTH * HEIGHT; i++) begin
            row = HEIGHT - 1 - (i / WIDTH); // 上から格納
            col = i % WIDTH;
            temp = $fgetc(file); // 1 バイト読み込む
            memory[row][col] = temp;
        end

        $fclose(file);
        $display("BMP file %s loaded successfully!", filename);
    endtask

    initial begin
        // BMP ファイルを読み込んでメモリに展開
        load_bmp("../pattern_image_05af.bmp");

        // 確認のため、一部のデータを表示
        $display("Top-left pixel: %h", memory[0][0]);
        $display("Bottom-right pixel: %h", memory[HEIGHT-1][WIDTH-1]);
		#1000;
    end
endmodule
