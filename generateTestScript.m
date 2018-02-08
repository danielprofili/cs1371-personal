% GENERATETESTSCRIPT Generate a test script for the current homework.
%   No options. Just run it in a homework folder and it will automatically
%   detect the hw#.m file and generate a test script containing the provided
%   test cases.
function varargout = generateTestScript()
fnames = dir('hw*.m');
if isempty(fnames)
    foldername = uigetdir(cd(), 'Select folder containing hw#.m file');
    if ~ischar(foldername)
        error('No folder selected. Terminating.');
    else
        cd(foldername);
        fnames = dir('hw*.m');
        if isempty(fnames)
            error('No hw#.m file found in the current directory.');
        end
    end
end

% correctFile = false;
% i = 1;
% % Get the correct file out of garbage
% while ~correctFile
%     cName = fnames(i).name;
%     if ~isempty(regexp(cName, 'hw[0-9]{2}\.m', 'once'))
%         correctFile = true;
%         hwFileName = cName;
%     end
%     i = i + 1;
% end

% TODO - test this
hwFileName = fnames(1).name;

% Get a file handle for the (hopefully) correct hw#.m file
fh = fopen(hwFileName);

line1 = fgetl(fh);
done = false;

% Cell array of lines to write to the test script
lines = {['%%%% Homework ', hwFileName(3:4), ' Test Script'];};
lines = [lines; {'clear, clc'}];

% optional output: return the 
if nargout > 0
    varargout = hwFileName(3:4);
end

%% 2) Click "Run" to test all problems.
while ischar(line1) && ~done
    % search for line beginning the test cases
    if ~isempty(strfind(line1, 'Function Name: '))
        % keep looking until the ------ line is found
        func1 = strtrim(line1(strfind(line1, 'Function Name: ') + length('Function Name:'):end));
        lines = [lines; {['%%%% Function: ', func1]}];
        % flags for non-variable outputs
        hasPlots = false;
        hasImages = false;
        hasFiles = false;
        
        testCaseNum = 1;
        while ischar(line1) && isempty(regexp(line1, '-{5,}'))
            if ~isempty(strfind(line1, 'Output plot'))
                hasPlots = true;
            end
            
            if ~isempty(strfind(line1, 'Output image'))
                hasImages = true;
            end
            
            if ~isempty(strfind(line1, 'Output text'))
                hasFiles = true;
            end
            
            
            % Looking for special .mat files to load
            if ~isempty(regexp(commentTrim(line1), 'load \w+\.mat', 'once'))
                lines = [lines; {commentTrim(line1)}];
                %             if ~isempty(strfind(line, 'Setup:'))
                %                 while isempty(strfind(line, 'load'))
                %                     line = fgetl(fh);
                %                 end
                %
                %                 % Add that line to the test script
                %                 line = line(strfind(line, 'load'):end);
                %                 lines = [lines; {line}];
                
            elseif isFunction(line1)
                % Open square bracket means the beginning of a test line
                line1 = line1(line1 ~= '%');
                lines = [lines; {[strtrim(line1), ';']}];
                [solnLine, checkLines, allLine] = parseOutputs(line1, func1, testCaseNum, hasFiles, hasPlots, hasImages);
                lines = [lines; {solnLine}; checkLines; {''};];
                if ~isempty(allLine)
                    lines = [lines; {allLine}; {''}];
                end
                
                testCaseNum = testCaseNum + 1;
                
            end
            line1 = fgetl(fh);
        end
        
        %         done = true;
        lines = [lines; {''}];
    end % done getting inputs
    line1 = fgetl(fh);
end % done looping through files
fclose(fh);

cell2file(lines, ['test_', hwFileName]);
disp(['test_', hwFileName, ' created in ', cd(), '.']);

end % end function generateTestScript


% Write an entire file at once via a cell array
function cell2file(ca, file)
if ~isempty(ca)
    fh = fopen(file, 'w');
    for i = 1:length(ca)
        if ~iscell(ca{i})
            fprintf(fh, [ca{i}, '\n']);
        end
    end
    fclose(fh);
end
end

% Get the output scheme from a line containing a homework function call.
function [ solnLine, checkLines, allLine, ca, ca_soln ] = parseOutputs(line1, funcName, num, hasFiles, hasPlots, hasImages)
line1 = strtrim(line1);
ca = {};
ca_soln = {};
% Check to see if the function actually has outputs - if it does, it'll
% match the regex
if ~isempty(regexp(line1, '\[((\w| )+)\] ?=? ?\w+\(.*\)'))
    
    % TODO - implement w/ regex
    bracketMatch = regexp(line1, '\[[\w, ]+\]', 'match');
    %
    
    % this way sucks but works (as far as I know)
    openBracket = strfind(line1, '[');
    openBracket = openBracket(1);
    
    closeBracket = strfind(line1, ']');
    closeBracket = closeBracket(1);
    
    outputs = line1(openBracket + 1:closeBracket - 1);
    
    [out, outputs] = strtok(outputs, ',');
    while ~isempty(out)
        ca = [ca, {strtrim(out)}];
        ca_soln = [ca_soln, {[strtrim(out), 's']}];
        [out, outputs] = strtok(outputs, ',');
    end
    
    
    % Generate new solution line and check line
    
    solnLine = line1;
    checkLines = {};
    checkVars = {};
    allLine = ['checkAll_', funcName, '_case', num2str(num), ' = all(['];
    for i = 1:length(ca)
        solnLine = strrep(solnLine, ca{i}, ca_soln{i});
        checkVar = ['check_', funcName, '_', num2str(num), '_', ca{i}];
        checkLines = [checkLines; [checkVar, ' = isequal(', ca{i}, ', ' ca_soln{i}, ')']];
        allLine = [allLine, checkVar, ', '];
    end
    
    solnLine = strrep(solnLine, funcName, [funcName, '_soln']);
    solnLine = [solnLine, ';'];
    allLine(end-1:end) = [];
    allLine = [allLine, '])'];
    
    if length(ca) == 1
        allLine = '';
    end
else
    % Function has no outputs, so don't output anything except the lines
    % calling the function + solution
    solnLine = strrep(line1, funcName, [funcName, '_soln']);
    checkLines = '';
    allLine = '';
end

if hasPlots
    % TODO
end

if hasFiles
%     [funcFiles, solnFiles] = findGeneratedFiles(line1, funcName);
end

if hasImages
    % TODO
end
end % end function parseOutputs

% Attempts to determine if the line is a function call.
% Will work for most functions of the forms below:
%   [out1] = someFunction(input1, input2, ...)
%   someFunction(input1, input2, ...)
%   someFunction()
function res = isFunction(line1)
res = ~isempty(regexp(line1, '\[?((\w| )+)?\]? ?=? ?\w+\(.*\)$', 'once'));
end

% Remove the leading percents from a string
function str = commentTrim(str)
    str(str == '%') = ' ';
    str = strtrim(str);
end

% Gets the name of image/file outputs by detecting changes in the files
% contained in the current directory.
function [funcFiles, solnFiles] = findGeneratedFiles(functionCall, funcName)
    % probably bad practice, but go and delete all text files/images that
    % look like they've been generated by homework functions
    filesBefore = dir();
    isDir = [filesBefore.isdir];
    filesBefore(isDir) = [];
    names = {filesBefore.name};
    
    % Delete solution and function-generated text files
    solnTxtFiles = dir('*_soln.txt');
    for i = 1:length(solnTxtFiles)
       solnName = solnTxtFiles(i).name;
       baseName = [solnName(1:strfind('_soln.txt') - 1), '.txt'];
       delete(solnName);
       delete(baseName); 
    end
    
    % do the same for images
    solnPngFiles = dir('*_soln.png');
    for i = 1:length(solnPngFiles)
       solnName = solnPngFiles(i).name;
       baseName = [solnName(1:strfind('_soln.png') - 1), '.png'];
       delete(solnName);
       delete(baseName); 
    end
    
    % Now call the function and the solution to determine name of generated
    % file(s)
    try
        eval(functionCall);
        eval(strrep(functionCall, funcName, [funcName, '_soln']));
    catch ME
       warning('Function ''%s'' errored! (%s) Cannot detect file outputs.', funcName, ME.identifier);
    end
    
    filesAfter = dir();
    fileDiff = setdiff({filesAfter.name}, {filesBefore.name});
    if isempty(fileDiff)
        warning('Detected no file outputs from ''%s''.')
    else
        
    end

end % end function findGeneratedFiles