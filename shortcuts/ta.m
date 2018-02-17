% TA Go to the TA homework directory
function varargout = ta()
    if isempty(nargout)
        if ispc
            cd 'C:\Users\Daniel\Documents\MATLAB\CS1371\TA S2018' % i think?
        else
            cd '/home/daniel/Documents/MATLAB/CS1371/2018Spr'
        end
    else
        if ispc
            varargout{1} = 'C:\Users\Daniel\Documents\MATLAB\CS1371\TA S2018'; % i think?
        else
            varargout{1} = '/home/daniel/Documents/MATLAB/CS1371/2018Spr';
        end
    end
end