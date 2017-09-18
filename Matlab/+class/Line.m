classdef Line < class.ItemGroup
    
    properties
        cycles %all time span from min date to max date from raw data
        cycleDur %cycle duration
        years_
        years
        months_
        months
        weeks_
        weeks
    end
    
    methods
        function this = Line(varargin)
            import class.LineItem;
%             import class.Cost;
            import class.LineStatus
            this = this@class.ItemGroup(varargin);
            this.years_ = LineStatus();
            this.months_ = LineStatus();
            this.months = containers.Map('KeyType','char', 'ValueType','any');
            this.weeks_ = LineStatus();
        end
        
        function suc = setProp(this,varargin)
            if length(varargin)==1;varargin = varargin{1};end;
            this.setProp@class.ItemGroup(varargin);
            this.setAddProp(varargin);
            suc = 1;
        end
        
        function suc = setAddProp(this,varargin)
            if length(varargin)==1;varargin = varargin{1};end;
            for i = 1:2:length(varargin)
                if  strcmpi(varargin{i}, 'Years'), this.years_  = varargin{i+1};
                elseif strcmpi(varargin{i}, 'Months'); this.months_  = varargin{i+1}; 
                elseif strcmpi(varargin{i}, 'Weeks'); this.weeks_  = varargin{i+1};
                elseif strcmpi(varargin{i}, 'cycles'); this.cycles  = varargin{i+1};
                elseif strcmpi(varargin{i}, 'cycleDuration'); this.cycleDur  = varargin{i+1};    
                end
            end
            suc = 1;
        end
        
        function suc = setMonthlyStatus(this)
            import class.LineStatus
            for i=1:1:length(this.cycles)
                this.months_(i) = LineStatus();
                cycleStr = datestr(this.cycles(i), lower(this.cycles.Format));
                this.months(cycleStr) = this.months_(i);
                
                this.months_(i).demand.sum.reset();
                for j=1:1:length(this.items_)
                    if any(this.items_(j).cycles==this.cycles(i))
                        this.months_(i).demand.addItem(this.items_(j));
                        this.months_(i).demand.sum.updateUsingItem(this.items_(j),cycleStr);
                    end
                end
                disp([this.name,': Set monthly sum for cycle: ', cycleStr,': success!']);
            end
            suc = 1;
        end
        
        function suc = getDemandInfoFromRawData(this,rawData,rowRange)
            import class.LineItem;
            import fun.findStringInCellArray;
            disp([this.name,': Start loading data...']);
            %find col idx of each properties
            if nargin<3;rowRange = [1:1:size(rawData.data,1)]';end;
            prodMethodColIdx = findStringInCellArray(rawData.head, 'ProdMethod');
            itemColIdx = findStringInCellArray(rawData.head, 'Item');
            
            lineRowIdx = findStringInCellArray(rawData.txt(rowRange,prodMethodColIdx),this.name,'all');
            
            lineItems = rawData.txt(rowRange(lineRowIdx), itemColIdx);
            
            [lineUniqueItems,~] = unique(lineItems,'stable');
            %entries that we know is unique to each item
            %entries that we not sure is unique to each item, need to check
            minCycle = datetime(2100,1,1);
            maxCycle = datetime(1800,1,1);
            for i=1:1:length(lineUniqueItems);
                itemIdxi = findStringInCellArray(rawData.txt(rowRange(lineRowIdx),itemColIdx),lineUniqueItems{i},'all');
                itemIdxiInRowRange = rowRange(lineRowIdx(itemIdxi));
%                 this.items_(i,1) = LineItem('Item',lineUniqueItems{i});
%                 this.items_(i,1).getInfoFromRawData(rawData,itemIdxiInRowRange);
                newItem = LineItem('Item',lineUniqueItems{i},'CycleDuration',this.cycleDur);
                newItem.getDemandInfoFromRawData(rawData,itemIdxiInRowRange);
                this.addItem(newItem);
                minCycle = min(minCycle,min(newItem.cycles));
                maxCycle = max(maxCycle,max(newItem.cycles));
                disp([this.name,': Load data of item: ',newItem.getKeyName(),': sucess!']);
            end
            
            %set data span unique to the line
%             this.cycles = sort(unique(cycleVec));
            this.cycles = [minCycle:this.cycleDur:maxCycle]';
            this.cycles.Format = newItem.cycles.Format;
            suc = 1;
        end 
        
        function dt = getCycles(this)
            dt = this.cycles;
            dt.Format = this.cycles.Format;
        end
 
    end
    
end