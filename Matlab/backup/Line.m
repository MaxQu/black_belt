classdef Line < handle
    
    properties
        name
        items_ %
        items %key map
        itemNum = 0;
        itemNames ={};
        demand
        prod
    end
    
    methods
        function this = Line(name)
            import class.LineItem;
            if nargin>=1; this.name = name;end;
            this.items_ = LineItem();
        end
        
        function getInfoFromRawData(this,rawData,rowRange)
            import class.LineItem;
            import fun.findStringInCellArray;
            import class.DemPlan;
            %find col idx of each properties
            if nargin<3;rowRange = [1:1:size(rawData.data,1)]';end;
            prodMethodColIdx = findStringInCellArray(rawData.head, 'ProdMethod');
            itemColIdx = findStringInCellArray(rawData.head, 'Item');
            descrColIdx = findStringInCellArray(rawData.head, 'DESCR');
            yrMthColIdx = findStringInCellArray(rawData.head, 'YrMth');
            
            lineRowIdx = findStringInCellArray(rawData.txt(rowRange,prodMethodColIdx),this.name,'all');
            
            lineItems = rawData.txt(rowRange(lineRowIdx), itemColIdx);
            
            [lineUniqueItems,lineUniqueItemsIdx] = unique(lineItems,'stable');
            %entries that we know is unique to each item
%             lineUniqueItemsDescr = rawData.txt(lineRowIdx(lineUniqueItemsIdx),descrColIdx);
            
            %entries that we not sure is unique to each item, need to check
            for i=1:1:length(lineUniqueItems);
                lineUniqueItemsIdxi = lineUniqueItemsIdx(i);
                itemi = lineUniqueItems{i};
%                 desrpi = lineUniqueItemsDescr{i};
                desrpi = rawData.txt(rowRange(lineRowIdx(lineUniqueItemsIdxi)),descrColIdx);
                
                itemRowIdx = findStringInCellArray(lineItems,itemi,'all');
                propNum = length(this.items_(1).propList);
                propCell = cell(2*propNum,1);
                
                for j=1:1:propNum;propCell{2*j-1} = this.items_(1).propList{j};end
                propCell{2*findStringInCellArray(this.items_(1).propList,'Item')} = itemi; 
                propCell{2*findStringInCellArray(this.items_(1).propList,'DESCR')} = desrpi;
                %find the production cycle
                yrMthVec = rawData.txt(rowRange(lineRowIdx(itemRowIdx)),yrMthColIdx);
                yrMthUni = unique(yrMthVec,'stable');
                
                if length(yrMthVec) ~= length(yrMthUni);
                    disp(['items prod YrMth not unique: ', itemi, ', ', desrpi]);
                end
                propCell{2*findStringInCellArray(this.items_(1).propList,'YrMth')} = yrMthUni;
                
                %for the rest numerical properties
                numPropIdxPool = find(strcmp(this.items_(1).propType,'num')==1);
                for j=1:1:length(numPropIdxPool);
                    ji = numPropIdxPool(j);
                    propName = this.items_(1).propList{ji};
                    propColIdx = findStringInCellArray(rawData.head,propName);
                    propCell{2*ji} = findItemNumProp(propName,propColIdx);
                end
                
                this.items_(i,1) = LineItem(propCell);
            end
            

            
            function prop = findItemNumProp(propName,propColIdx)
                propMean = mean(rawData.data(lineRowIdx(itemRowIdx),propColIdx));
                propUni = rawData.data(lineRowIdx(lineUniqueItemsIdxi),propColIdx);
                if abs(propMean-propUni) > 0.01 * propUni;
                    disp(['items properties not unique to: ', itemi, ', ', desrpi, ', ', propName]);
                end
                prop = propMean;
            end
            
            this.demand = DemPlan();


        end
        
        function addItem(this,newItem)
            len = length(newItem);
            for i=1:1:len
                this.lines_(this.num+i,1) = newItem(i);
                newItemName = newItem(i).getKeyName();
                if this.items.isKey(newItemName)
                    error('the line key already exists, cannot add new line');
                end
                this.items(newItemName) = this.items_(this.itemNum+1,1);
            end
            this.getNum();
            this.getNames();
        end
        
        function n = getItemNum(this)
%             this.lineNum = size(this.lines_,1) * size(this.lines_,2);
            this.itemNum = length(this.items_);
            n = this.itemNum;
        end
        
        function ns = getItemNames(this)
            this.itemNames = cell(this.itemNum,1);
            for i=1:1:this.itemNum
                this.itemNames{i} = this.items_(i).name;
            end
            ns = this.itemNames;
        end
        
        function ks = getKeys(this)
            ks = this.items.keys()';
        end
        
        function setName(this,newName)
            this.name = newName;
        end
        
        function lineKey = getKeyName(this)
            % lineNameStartIdx = strfind(this.name,'LINE')+5;
            % lineKey = this.name(lineNameStartIdx:min(lineNameStartIdx+5,length(this.name)));
            lineKey = this.name(1:min(15,length(this.name)));

        end
    end
    
end