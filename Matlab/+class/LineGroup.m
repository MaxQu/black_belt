classdef LineGroup < handle
    
    
    properties
        name %this line group name
        lines_ %lines_ vector
        lines %lines key map
        lineNum = 0; %num of lines_
        lineNames = {};%lineNames
    end
    
    methods
        function this = LineGroup(varargin)
            import class.Line;
            if length(varargin)==1;varargin = varargin{1};end;
            this.lines = containers.Map('KeyType','char', 'ValueType','any');
            this.lines_ = Line();
            this.setProp(varargin);
        end
        
        function suc = setProp(this,varargin)
            if length(varargin)==1;varargin = varargin{1};end;
            for i = 1:2:length(varargin)
                if  strcmpi(varargin{i}, 'Name'), this.name  = varargin{i+1};
                elseif strcmpi(varargin{i}, 'Lines'); this.lines_  = varargin{i+1}; this.setLineKeyMap();
                end
            end
            suc = 1;
        end
        
        function suc = setLineKeyMap(this)
            this.getLineNum();
            for i =1:1:this.lineNum
                this.lines(this.lines_(i).getKeyName()) = this.lines_(i);
            end
            this.getLineNames();
            suc = 1;
        end
        
        function n = getLineNum(this)
%             this.lineNum = size(this.lines_,1) * size(this.lines_,2);
            this.lineNum = length(this.lines_);
            n = this.lineNum;
        end
        
        function ns = getLineNames(this)
            this.lineNames = cell(this.lineNum,1);
            for i=1:1:this.lineNum
                this.lineNames{i} = this.lines_(i).name;
            end
            ns = this.lineNames;
        end
        
        function ks = getKeys(this)
            ks = this.lines.keys()';
        end
        
        function suc = addLine(this,newLine)
            len = length(newLine);
            for i=1:1:len
                this.lines_(this.lineNum+i,1) = newLine(i);
                newLineName = newLine(i).getKeyName();
                if this.lines.isKey(newLineName)
                    error('the line key already exists, cannot add new line');
                end
                this.lines(newLineName) = this.lines_(this.lineNum+1,1);
            end
            this.getLineNum();
            this.getLineNames();
            suc = 1;
        end
        
        function suc = removeLine(this,lineName)
            if ~iscell(lineName);lineNameCell = cell(1,1);lineNameCell{1}=lineName;end;
            for i=1:1:length(lineNameCell);
%                 isLine = this.lines.isKey(lineNameCell{i});
                idxLine = this.findLineIdxUsingKey(lineNameCell{i});
                isLine = ~isempty(idxLine);
                if isLine
                    this.lines.remove(this.lines_(idxLine).getKeyName());
                    this.lines_(idxLine) = [];
                    this.getLineNum();
                    this.getLineNames();
                end
            end
            suc = 1;
        end
        
        function [res,idx] = hasLine(this,longName)
            idx = find(strcmp(this.lineNames,longName)==1);
            res = length(idx)>1;
        end
        
        function line = getLine(this,name)
            import fun.findStringInCellArray;
            idx = findStringInCellArray(this.lineNames,name);
            line = this.lines_(idx,1);
        end
        
        function idxAfterCheck = findLineIdxUsingKey(this,keyName)
           idx = [];
           for i=1:1:this.lineNum;
               if strfind(this.lineNames{i},keyName);
                   idx = [idx;i];
               end
           end
           
           if length(idx)>1;
               %check if one of the long name is exactly the key
               idxAfterCheck = [];
               for i=1:1:length(idx);
                   if strcmp(this.lineNames{idx(i)},keyName)
                       idxAfterCheck = [idxAfterCheck;idx(i)];
                   end
               end
               if isempty(idxAfterCheck);idxAfterCheck= idx;end
           else
               idxAfterCheck = idx;
           end
           
           if length(idxAfterCheck)>1;
               error('key is not unique');
           end
        end        
    end
    
    methods (Access = private)
         function pruneLineWithEmptyName(this,idx)
             %has to be used with prune of the lines map
            if nargin<2
                idx = [];
                for i=1:1:this.lineNum
                    if isempty(this.lines_(i).name)
                        idx = [idx;i];
                    end
                end
            end
            this.lines_(idx) = [];
        end
    end
    
end