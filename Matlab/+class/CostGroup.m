classdef CostGroup < class.ItemGroup
    
    properties
       sum %sum of all cost
    end
    
    methods 
        
        function this = CostGroup(varargin)
            if length(varargin)==1;varargin = varargin{1};end;
            this = this@class.ItemGroup(varargin);
            import class.Cost;
            this.sum = Cost();
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
                if  strcmpi(varargin{i}, 'sum'), this.sum  = varargin{i+1}; this.getCostNum();
                end
            end
            suc = 1;
        end
        
    end
    
end
    
    