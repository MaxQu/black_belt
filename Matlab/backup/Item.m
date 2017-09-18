classdef Item < handle
   
    properties
       sku
       descr
       stdCost
       schePrice
       netWeight
       
       %propList should be in the order of properties
       propList = {'Item','DESCR','StdCost','UDC_SCHEDPRICE','UDC_NET_WEIGHT_AMT'};
       propType = {'txt','txt','num','num','num'};
       numProp
    end
    
    methods
        
        function this = Item(varargin)
            if length(varargin)==1;varargin = varargin{1};end;
            this.setProp(varargin);
        end
        
        function setProp(this,varargin)
            if length(varargin)==1;varargin = varargin{1};end;
            this.numProp = length(this.propList);
            for i = 1:2:length(varargin)
                if  strcmp(varargin{i}, this.propList{1}), this.sku  = varargin{i+1};
                elseif strcmp(varargin{i}, this.propList{2}); this.descr  = varargin{i+1};
                elseif strcmp(varargin{i}, this.propList{3}); this.stdCost  = varargin{i+1};
                elseif strcmp(varargin{i}, this.propList{4}); this.schePrice  = varargin{i+1};
                elseif strcmp(varargin{i}, this.propList{5}); this.netWeight  = varargin{i+1};
                end
            end
        end
        
        function kn = getKeyName(this)
            kn = this.sku;
        end
    
    end
    
    
end