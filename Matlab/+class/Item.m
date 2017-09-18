classdef Item < handle
   
    properties
       sku
       descr
       stdCost
       schePrice
       netWeight
       
       %%%%%%%%%%%%%%%%%%%user input %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       %propList should be in the order of properties
       propList = {'Item','DESCR','StdCost','UDC_SCHEDPRICE','UDC_NET_WEIGHT_AMT'};%enter excel sheet head line
       propType = {'txt','txt','num','num','num'};%enter if its is a numerical or txt properties, one-to-one corresponding to propList
       numProp
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end
    
    methods
        
        function this = Item(varargin)
            if length(varargin)==1;varargin = varargin{1};end;
            this.setProp(varargin);
        end
        
        function suc = setProp(this,varargin)
            if length(varargin)==1;varargin = varargin{1};end;
            this.numProp = length(this.propList);
            for i = 1:2:length(varargin)
                if  strcmpi(varargin{i}, this.propList{1}), this.sku  = varargin{i+1};
                elseif strcmpi(varargin{i}, this.propList{2}); this.descr  = varargin{i+1};
                elseif strcmpi(varargin{i}, this.propList{3}); this.stdCost  = varargin{i+1};
                elseif strcmpi(varargin{i}, this.propList{4}); this.schePrice  = varargin{i+1};
                elseif strcmpi(varargin{i}, this.propList{5}); this.netWeight  = varargin{i+1};
                end
            end
            suc = 1;
        end
        
        function kn = getKeyName(this)
            kn = this.sku;
        end
        
        function suc = getDemandInfoFromRawData(this,rawData,rowRange)
            import fun.findStringInCellArray;
            if nargin<3;rowRange = [1:1:size(rawData.data,1)]';end;
            skui = this.sku; 
            itemColIdx = findStringInCellArray(rawData.head, 'Item');
            itemRowIdx = findStringInCellArray(rawData.txt(rowRange,itemColIdx),skui,'all');
            uniqueItemPropIdx = 1;%only takes in the first item properties
            descrColIdx = findStringInCellArray(rawData.head, 'DESCR');
            desrpi = rawData.txt(rowRange(itemRowIdx(uniqueItemPropIdx)),descrColIdx);
            
            propNum = length(this.propList);
            propCell = cell(2*propNum,1);
            
            for j=1:1:propNum;propCell{2*j-1} = this.propList{j};end
            propCell{2*findStringInCellArray(this.propList,'Item')} = skui;
            propCell{2*findStringInCellArray(this.propList,'DESCR')} = desrpi;
%             fprintf(['Item: ',this.sku, ': ']);fprintf('Descrp, ');
            %for the rest numerical properties
            numPropIdxPool = find(strcmp(this.propType,'num')==1);
            for j=1:1:length(numPropIdxPool);
                ji = numPropIdxPool(j);
                propName = this.propList{ji};
                propCell{2*ji} = findItemNumPropMean(propName);
%                 fprintf([propName,', ']);
            end
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            this.setProp(propCell);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            function prop = findItemNumPropMean(propName)
                import fun.findStringInCellArray;
                propColIdx = findStringInCellArray(rawData.head,propName);
                propMean = mean(rawData.data(rowRange(itemRowIdx),propColIdx));
                propUni = rawData.data(rowRange(itemRowIdx(uniqueItemPropIdx)),propColIdx);
                if abs(propMean-propUni) > 0.01 * propUni;
                    disp(['items properties not unique to: ', skui, ', ', desrpi, ', ', propName]);
                end
                prop = propMean;
            end
            
            
            
            suc = 1;
        end
    end
    
    
end