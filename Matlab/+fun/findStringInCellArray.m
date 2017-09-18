function idx = findStringInCellArray(cell,str,method)
    if nargin<3;method = 'first';end
    idx = [];
%     len = length(str);
    for i=1:1:length(cell)
        if strcmp(cell{i},str)
            idx = [idx;i];
            if strcmp(method,'first')
                return
            end
        end
    end
end