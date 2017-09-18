classdef Production < class.PlanGroup
    
    properties

    end
    
    methods
        function this = Production(varargin)
            if nargin==1;varargin = varargin{1};end;
            this = this@class.PlanGroup(varargin);
        end
        
    end
    
end