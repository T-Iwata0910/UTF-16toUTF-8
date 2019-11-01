function utf16toutf8(fname, varargin)
    % utf16toutf8 - UTF-16形式のファイルをUTF-8形式に変換
    % この関数はUTF-16形式のファイルをUTF-8形式に変換し保存する関数です
    
    %% パーサの設定
    defaultSavaDir = 'outputs';
    p = inputParser;
    addRequired(p, 'fname', @ischar);
    addParameter(p, 'outputDir', defaultSavaDir, @ischar);
    parse(p, fname, varargin{:});
    
    %% ファイルの読み込み
    if(exist(p.Results.fname) ~= 2)
        disp('渡されたファイル名を持つファイルは存在しません');
    end
    fid = fopen(p.Results.fname, 'r');
    if(fid == -1)
        disp('読み込み用のファイルを開けませんでした');
        return;
    end
    bytes = fread(fid);
    fclose(fid);
    
    %% UTF-8に不要なバイト列の削除
    bytes(1:2) = [];
    if(any(bytes(2:2:end) ~= 0))
        disp('ファイルの中に3バイト以上の文字が含まれているため，このプログラムでは正常に変換することはできません');
        disp('プログラムを終了します．');
        return;
    end
    asciibytes = bytes(1:2:end);
    
    %% 結果をUTF-8で保存
    % 保存先フォルダが無いときにフォルダを作成
    if(exist(p.Results.outputDir) ~= 7)
        mkdir(p.Results.outputDir)
    end
    
    [~, name, ext] = fileparts(p.Results.fname);
    outputFileName = [p.Results.outputDir '/' name '_utf8' ext];
    fid = fopen(outputFileName, 'w', 'n', 'UTF-8');
    if(fid == -1)
        disp('書き込み用のファイルを開けませんでした');
        return;
    end
    fwrite(fid, asciibytes);
    fclose(fid);  
end

