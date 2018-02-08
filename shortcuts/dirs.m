% DIRS Shows a list of all the directory shortcuts in the MATLAB folder.
function dirs( )
    clc
    BASE_DIR = gd();
    if ispc
       BASE_DIR = [BASE_DIR, '\']; 
    else
        BASE_DIR = [BASE_DIR, '/'];
    end
    files = dir([BASE_DIR, '*.m']);
    files = {files.name};
    for f = files
       fh = fopen(f{1});
       line1 = fgetl(fh);
       desc = [];
       while ischar(line1) && isempty(strfind(line1, '   ')) && isempty(strfind(line1, 'function'))
           desc = [desc, strtrim(line1(2:end))];
           line1 = fgetl(fh);
       end
       fclose(fh);
       fprintf('- %s\n', desc);
    end
end

