classdef Company < class.LineGroup
    
    properties
        cycles
        cycleDur = calmonths(1);
    end
    
    
    methods
        function this = Company(varargin)
            if length(varargin)==1;varargin = varargin{1};end;
            this = this@class.LineGroup(varargin);
            this.setAddProp(varargin);
        end
        function suc = setProp(this,varargin)
            if length(varargin)==1;varargin = varargin{1};end;
            this.setProp@class.LineGroup(varargin);
            this.setAddProp(varargin);
            suc = 1;
        end
        function suc = setAddProp(this,varargin)
            if length(varargin)==1;varargin = varargin{1};end;
            for i = 1:2:length(varargin)
                if  strcmpi(varargin{i}, 'cycles'), this.cycles  = varargin{i+1}; this.getCostNum();
                elseif  strcmpi(varargin{i}, 'cycleDuration'), this.cycleDur  = varargin{i+1}; this.getCostNum();    
                end
            end
            suc = 1;
        end
        
        function suc = setMonthlyStatus(this)
            for i=1:1:this.lineNum
                this.lines_(i).setMonthlyStatus();
            end
        end
        
        function suc = getDemandInfoFromRawData(this,rawData)
            import class.Line;
            import fun.findStringInCellArray;
            disp([this.name,': Start loading data...']);
            prodMethodColIdx = findStringInCellArray(rawData.head,'ProdMethod');
            linNames = unique(rawData.txt(:,prodMethodColIdx),'stable');
            numLines = length(linNames);
            this.lines_ = Line();
            
            minCycle = datetime(2100,1,1);
            maxCycle = datetime(1800,1,1);
            for i=1:1:numLines
                newLine = Line('Name',linNames{i},'CycleDuration',this.cycleDur);
                newLine.getDemandInfoFromRawData(rawData);%since line is unique in this data set
                this.addLine(newLine);
                minCycle = min(minCycle,newLine.cycles(1));
                maxCycle = max(maxCycle,newLine.cycles(end));
                disp([this.name, ': Load data of line: ',newLine.getKeyName(),': sucess!']);
            end
%             this.cycles = sort(unique(cycleVec));
            this.cycles = [minCycle:this.cycleDur:maxCycle]';
            this.cycles.Format = newLine.cycles.Format;
            suc = 1;
        end
        
        function dt = getCycles(this)
            dt = this.cycles;
            dt.Format = this.cycles.Format;
        end
        
    end
    
end