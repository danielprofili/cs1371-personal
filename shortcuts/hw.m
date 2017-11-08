% HW Find a specific homework folder.
%   hw(NUM) opens the folder corresponding to HW #NUM.

function hw(varargin)
% base directory where all the homework folders are saved
BASE_DIR = ta();

cd(BASE_DIR);

files = dir();
files = files([files.isdir]);
names = {files.name};

if ~isempty(varargin)
    if length(varargin) > 1 && ischar(varargin{2})
        cd(varargin{2});
    end
    if isnumeric(varargin{1})
        mask = strcmp(names, ['HW', num2str(varargin{1})]);
        files(~mask) = [];
        if length(files) > 1
            fprintf('Found %d possible matches:\n', length(files));
            for i = 1:length(files)
                fprintf(' - %s\\\n', files(i).name);
            end
        elseif length(files) == 1
            cd(files(1).name);
        else
            try 
                hw(['0', num2str(varargin{1})])
            catch
            end
            error('Couldn''t find HW %d.', varargin{1});
        end
        
    elseif ischar(varargin{1})
        try
            cd(varargin{1});
        catch
        end
    end
end

end