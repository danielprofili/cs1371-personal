% TA Go to the TA homework directory
function varargout = ta()
    if isempty(nargout)
        cd 'C:\Users\Daniel\Documents\MATLAB\CS1371\TA F2017'
    else
        varargout{1} = 'C:\Users\Daniel\Documents\MATLAB\CS1371\TA F2017';
    end
end