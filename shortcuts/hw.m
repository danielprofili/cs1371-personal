% HW Find a specific homework folder.
%   hw(NUM) opens the folder corresponding to HW #NUM.


function hw(varargin)
% base directory where all the homework folders are saved
BASE_DIR = ta();

cd(BASE_DIR);

files = dir();
files = files([files.isdir]);
names = {files.name};

if ~isempty(varargin) && ischar(varargin{1})
    if strcmp(num2str(str2num(varargin{1})), varargin{1})
        varargin{1} = str2num(varargin{1});
    else
        % non-numeric character input  
        
        error('Invalid input ''%s''!', varargin{1})
    end
end

if ~isempty(varargin)
    if length(varargin) > 1 && ischar(varargin{2})
        cd(varargin{2});
    end
    if isnumeric(varargin{1})
        if varargin{1} < 10
            numStr = ['0', num2str(varargin{1})];
        else
            numStr = num2str(varargin{1});
        end
        mask = strcmp(names, ['HW', numStr]);
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
    % todo - change this - it no longer works like this    
    elseif ischar(varargin{1})
        try
            cd(varargin{1});
        catch
        end
    end
end

end