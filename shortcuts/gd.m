% GD Opens the git directory
function varargout = gd()
if nargout == 0
    if ispc
        cd('C:\Users\Daniel\Documents\CS1371');
    else
        cd /home/daniel/cs1371/cs1371-personal/shortcuts
    end
else
    if ispc
        varargout{1} = 'C:\Users\Daniel\Documents\CS1371';
    else
        varargout{1} = '/home/daniel/cs1371/cs1371-personal/shortcuts';
    end
end
end