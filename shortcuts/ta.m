% TA Go to the TA homework directory
function varargout = ta()
    if isempty(nargout)
<<<<<<< HEAD
        cd 'C:\Users\Daniel\Documents\MATLAB\CS1371\TA S2018'
    else
        varargout{1} = 'C:\Users\Daniel\Documents\MATLAB\CS1371\TA S2018';
=======
        if ispc
            cd 'C:\Users\Daniel\Documents\MATLAB\CS1371\TA F2017'
        else
            cd '/home/daniel/Documents/MATLAB/CS1371/2017Fall'
        end
    else
        varargout{1} = '/home/daniel/Documents/MATLAB/CS1371/2017Fall';
>>>>>>> 49e6418e133a06b3212f72c7f9f972241616e8f0
    end
end