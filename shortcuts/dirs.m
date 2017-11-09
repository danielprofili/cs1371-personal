% DIRS Shows a list of all the directory shortcuts in the MATLAB folder.
function dirs( )
    clc
    files = dir('C:\Users\Daniel\Documents\CS1371\cs1371-personal\shortcuts\*.m');
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

