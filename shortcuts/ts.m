% TS Find a test script for a specific homework.
%
%   ts() opens the test script for the homework in the current directory,
%   if used in a homework directory.
%
%   ts(NUM) opens the test script for homework #NUM. If a test script does
%   not exist, but the homework folder does, a test script is created.
%   
%   ts(NUM, 'nocreate') opens the test script for homework #NUM, but
%   doesn't create a test script if none is found.

function ts(varargin)
if ~isempty(varargin)
    hw(varargin{1});
    
    nocreate = false;
    if length(varargin) > 1 && strcmpi(varargin{2}, 'nocreate')
        nocreate = true;
    end
    
    if length(num2str(varargin{1})) < 2
        varargin{1} = ['0', num2str(varargin{1})];
    end
    
    if exist(['test_hw', num2str(varargin{1})], 'file')
        edit(['test_hw', num2str(varargin{1})]);
    elseif ~nocreate
        generateTestScript();
        ts(varargin{1}, 'nocreate');
    end
else
   % try to do ts with the current folder
   cname = cd;
   ts(cname(strfind(cname, 'HW') + 2:end));
    
end
end