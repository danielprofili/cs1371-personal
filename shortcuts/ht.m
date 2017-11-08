% HT Open the Homework Team drive folder.
%    htDir(NUM) opens the folder for Homework NUM, if it exists.
function ht(varargin)
% location of the base directory
BASE_DIR = 'C:\Users\Daniel\Google Drive\Homework Team\201703_FAL';

cd(BASE_DIR)
if ~isempty(varargin) && isnumeric(varargin{1})
    files = dir();
    files = files([files.isdir]);
    names = {files.name};
    if length(num2str(varargin{1})) > 1
        hwStr = ['HW', num2str(varargin{1})];
    else
        hwStr = ['HW0', num2str(varargin{1})];
    end
    nameMask = ~cellfun(@isempty, strfind(names, hwStr));
    files(~nameMask) = [];
    if length(files) > 1
        fprintf('Found %d possible matches:\n', length(files));
        for i = 1:length(files)
            fprintf(' - %s\\\n', files(i).name);
        end
    elseif length(files) == 1
        cd(files(1).name);
    else
        error('Couldn''t find HW %d.', varargin{1});
    end
    
end
end