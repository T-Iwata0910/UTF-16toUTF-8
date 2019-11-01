function utf16toutf8(fname, varargin)
    % utf16toutf8 - UTF-16�`���̃t�@�C����UTF-8�`���ɕϊ�
    % ���̊֐���UTF-16�`���̃t�@�C����UTF-8�`���ɕϊ����ۑ�����֐��ł�
    
    %% �p�[�T�̐ݒ�
    defaultSavaDir = 'outputs';
    p = inputParser;
    addRequired(p, 'fname', @ischar);
    addParameter(p, 'outputDir', defaultSavaDir, @ischar);
    parse(p, fname, varargin{:});
    
    %% �t�@�C���̓ǂݍ���
    if(exist(p.Results.fname) ~= 2)
        disp('�n���ꂽ�t�@�C���������t�@�C���͑��݂��܂���');
    end
    fid = fopen(p.Results.fname, 'r');
    if(fid == -1)
        disp('�ǂݍ��ݗp�̃t�@�C�����J���܂���ł���');
        return;
    end
    bytes = fread(fid);
    fclose(fid);
    
    %% UTF-8�ɕs�v�ȃo�C�g��̍폜
    bytes(1:2) = [];
    if(any(bytes(2:2:end) ~= 0))
        disp('�t�@�C���̒���3�o�C�g�ȏ�̕������܂܂�Ă��邽�߁C���̃v���O�����ł͐���ɕϊ����邱�Ƃ͂ł��܂���');
        disp('�v���O�������I�����܂��D');
        return;
    end
    asciibytes = bytes(1:2:end);
    
    %% ���ʂ�UTF-8�ŕۑ�
    % �ۑ���t�H���_�������Ƃ��Ƀt�H���_���쐬
    if(exist(p.Results.outputDir) ~= 7)
        mkdir(p.Results.outputDir)
    end
    
    [~, name, ext] = fileparts(p.Results.fname);
    outputFileName = [p.Results.outputDir '/' name '_utf8' ext];
    fid = fopen(outputFileName, 'w', 'n', 'UTF-8');
    if(fid == -1)
        disp('�������ݗp�̃t�@�C�����J���܂���ł���');
        return;
    end
    fwrite(fid, asciibytes);
    fclose(fid);  
end

