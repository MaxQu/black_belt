classdef LineStatus < handle
    
    properties
        demand_
        demand
        capacity_
        capacity
        production
    end
    
    methods
        function this = LineStatus(varargin)
            import class.CostGroup;
            import class.Production
            if length(varargin)==1;varargin = varargin{1};end;
            this.demand = CostGroup();
            this.capacity = CostGroup();
            this.production = Production();
            this.setProp(varargin);
        end
        
        function suc = setProp(this,varargin)
            if length(varargin)==1;varargin = varargin{1};end;
            for i = 1:2:length(varargin)
                if  strcmpi(varargin{i}, 'demand'), this.demand_  = varargin{i+1};
                elseif strcmpi(varargin{i}, 'capacity'); this.capacity_  = varargin{i+1};
                elseif strcmpi(varargin{i}, 'prodPlan'); this.production  = varargin{i+1};    
                end
            end
            suc = 1;
        end
    end
    
end