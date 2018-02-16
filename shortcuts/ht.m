% HT Open the Homework Team drive folder.
%    ht NUM opens the folder for Homework NUM, if it exists.
%    DIRECTORYNAME = ht returns the base directory name.

% TODO
% - Allow searching for homework problem names
% - Command line options?
function varargout = ht(varargin)
% location of the base directory
% BASE_DIR = ta();
if ispc
    % TODO
else
    BASE_DIR = '/home/daniel/Documents/Google Drive/Homework Team/201801_SPR';
end

cd(BASE_DIR)
if ~isempty(varargin)
    if ischar(varargin{1})
        if strcmp(num2str(str2num(varargin{1})), varargin{1})
            varargin{1} = str2num(varargin{1});
        else
            error('Invalid input ''%s''!', varargin{1})
        end
    end

    if ~isempty(varargin)
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
end