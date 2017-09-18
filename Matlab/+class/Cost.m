classdef Cost < handle
    
    properties
        lbs = 0;
        dollars = 0;
        revenue = 0;
        hours = 0;
        quant = 0;
    end
    
    methods 
        
        function this = Cost(varargin)
            if length(varargin)==1;varargin = varargin{1};end;
            this.setProp(varargin);
        end
        
        function suc = setProp(this,varargin)
            if length(varargin)==1;varargin = varargin{1};end;
            for i = 1:2:length(varargin)
                if  strcmpi(varargin{i}, 'lbs'), this.lbs  = varargin{i+1};
                elseif strcmpi(varargin{i}, 'dollars'); this.dollars  = varargin{i+1};
                elseif strcmpi(varargin{i}, 'houars'); this.hours  = varargin{i+1};
                elseif strcmpi(varargin{i}, 'quantity'); this.quant  = varargin{i+1};
                elseif strcmpi(varargin{i}, 'revenue'); this.revenue  = varargin{i+1};     
                end
            end
            suc = 1;
        end
        
        function suc = reset(this)
            this.lbs = 0;
            this.dollars = 0;
            this.hours = 0;
            this.quant = 0;
            this.revenue = 0;
            suc = 1;
        end
        
        function suc = updateUsingItem(this,lineItem,cycleStr)
            quantity = lineItem.demand.plans(cycleStr).quant;
            this.quant = this.quant + quantity;
            this.lbs = this.lbs + quantity* lineItem.netWeight;
            this.hours = this.hours + quantity/lineItem.prodRate;
            this.dollars = this.dollars + quantity*lineItem.stdCost;
            this.revenue = this.revenue + quantity*lineItem.schePrice;
            suc = 1;
        end
        
        
        
    end
    
end
    
    