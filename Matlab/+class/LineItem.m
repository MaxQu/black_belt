classdef LineItem < class.Item
   
    properties
       %%%%%%%add to the superclass properties%%%%%%%%%%%
       yrMth
       prodRate
       quant
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       numAddProp
       cycles  %date time vec span from min start time, to the max start time
       cycleDur %specify cycleDur
       demand %pointer to demand plan group
       supply %pointer to supply plan group
    end
    
    methods
        
        function this = LineItem(varargin)
            import class.PlanGroup
            if length(varargin)==1;varargin = varargin{1};end; 
            this = this@class.Item(varargin);
            %%%%%%%%%%%%%%%%%%%user input %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            this.propList = [this.propList,'YrMth','PRODRATE','Qty'];%enter excel sheet head line
            this.propType = [this.propType,'txtVar','num','numVar'];%enter if its is 1. unique txt, 2. unique num, 3. key map, 4, variable that are different for each entry, one-to-one corresponding to propList
            this.numAddProp = 3; %added three additional properties
            %%%%%%%%%%%%%%%%%%%user input %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            this.numProp = length(this.propList);
            this.demand = PlanGroup();
            this.supply = PlanGroup();
            this.setAddProp(varargin);
        end
        
        function suc = setProp(this,varargin)
            if length(varargin)==1;varargin = varargin{1};end;
            this.setProp@class.Item(varargin);
            this.setAddProp(varargin);
            suc = 1;
        end
        
        function suc = setAddProp(this,varargin)
            if isempty(this.numAddProp);return;end;
            if length(varargin)==1;varargin = varargin{1};end;
            for i = 1:2:length(varargin)
                if  strcmpi(varargin{i}, this.propList{this.numProp-this.numAddProp+1}); this.yrMth  = varargin{i+1};
                elseif strcmpi(varargin{i}, this.propList{this.numProp-this.numAddProp+2}); this.prodRate  = varargin{i+1};
                elseif strcmpi(varargin{i}, this.propList{this.numProp-this.numAddProp+3}); this.quant  = varargin{i+1};
                elseif strcmpi(varargin{i}, 'Demand'); this.demand  = varargin{i+1};
                elseif strcmpi(varargin{i}, 'CycleDuration'); this.cycleDur  = varargin{i+1};
                end
            end
            suc = 1;
        end
        
        
        function suc = getDemandInfoFromRawData(this,rawData,rowRange)
            if nargin<3;rowRange = [1:1:size(rawData.data,1)]';end;
            suc = getDemandInfoFromRawData@class.Item(this,rawData,rowRange);
            %find the production cycle
            import fun.findStringInCellArray;
            import class.Plan;
            itemColIdx = findStringInCellArray(rawData.head, 'Item');
            itemRowIdx = findStringInCellArray(rawData.txt(rowRange,itemColIdx),this.sku,'all');
            yrMthColIdx = findStringInCellArray(rawData.head, 'YrMth');
            yrMthVec = rawData.txt(rowRange(itemRowIdx),yrMthColIdx);
            yrMthUni = unique(yrMthVec,'stable');
            
            if length(yrMthVec) ~= length(yrMthUni);
                disp(['items prod YrMth not unique: ', this.sku, ', ', this.descr]);
            end
            
            quantVec = findItemNumPropVec('Qty');
            this.setProp('YrMth',yrMthVec,'Qty',quantVec);
%             fprintf('Qty, YrMth, ');


            %deal with 0 schedule price
            propName = 'UDC_SCHEDPRICE';
            if this.schePrice == 0 || isempty(this.schePrice);
                ttlVec = findItemNumPropVec('TTL_$');
                priceVec = ttlVec./this.quant;
                meanPriceVec = mean(priceVec);
                if abs(meanPriceVec-priceVec(1)) > 0.01 * priceVec(1);
                    disp(['items properties not unique to: ', skui, ', ', desrpi, ', ',propName]);
                end
                this.setProp(propName,meanPriceVec);
%                 fprintf('SchePrice Adjusted. \n');
            end
            
            
            function propVec =findItemNumPropVec(propName)
                import fun.findStringInCellArray;
                propColIdx = findStringInCellArray(rawData.head,propName);
                propVec = rawData.data(rowRange(itemRowIdx),propColIdx);
            end
            

            %%deal with the demand plan pointer
            [yearIdx, monthIdx, dayIdx, hourIdx] = this.parseDateTime(yrMthVec);
%             cycleDurationHours = 0; %hours
            for i=1:1:length(yrMthVec)
                startTime = datetime(str2double(yrMthVec{i}(yearIdx)),str2double(yrMthVec{i}(monthIdx)), 1, 0, 0, 0);
%                 if i<length(yrMthVec)
%                     endTime = datetime(str2double(yrMthVec{i+1}(yearIdx1:yearIdx2)),str2double(yrMthVec{i+1}(monthIdx1:monthIdx2)), 0);
%                     newCycleDurationHours = hours(endTime - startTime);
%                     if i==1;cycleDurationHours = newCycleDurationHours;end;
%                     if abs(cycleDurationHours - newCycleDurationHours) > 5*24;
%                         error('production cycle duration time is not even');
%                     end
%                     cycleDurationHours = newCycleDurationHours;
%                 else
%                     endTime = startTime + hours(cycleDurationHours);
%                 end
                endTime = startTime + this.cycleDur;
                newPlan = Plan('Item',this.sku,'StartTime',startTime,'EndTime', endTime, 'quantity',quantVec(i));
                this.demand.addPlan(newPlan);
            end
            this.cycles = this.demand.getCycles();
%             fprintf('Demand plan made. \n');
            
        end
        
        function [yearIdx,monthIdx, dayIdx, hourIdx] = parseDateTime(this,yrMthVec)
            yearIdx1 = strfind(yrMthVec{1},'20');
            yearIdx2 = yearIdx1+3;
            yearIdx = [yearIdx1:yearIdx2]';
            if (length(yrMthVec{1}) - yearIdx2) <=2;
                monthIdx2 = yearIdx1-2;
                monthIdx1 = monthIdx2-1;
            else
                monthIdx1 = yearIdx2+2;
                monthIdx2 = monthIdx1+1;
            end
            monthIdx = [monthIdx1:monthIdx2]';
            dayIdx = [];
            hourIdx = [];
        end      
        
        function dt = getCycles(this)
            dt = this.cycles;
            dt.Format = this.cycles.Format;
        end
    end
    
    
end