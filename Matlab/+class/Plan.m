classdef Plan < handle
    properties
        item %item sku or item pointer
        timeFormat = 'MMM-dd-yyyy: HH'; %timeFormat
        startTime = datetime(); %start date
        endTime = datetime(); %end date
        quant = 0; %quantities
    end
    
    methods
        function this = Plan(varargin)
            if length(varargin)==1;varargin = varargin{1};end;
            this.setProp(varargin);
        end
        
        function suc = setProp(this,varargin)
            if length(varargin)==1;varargin = varargin{1};end;
            for i = 1:2:length(varargin)
                if  strcmpi(varargin{i}, 'Item'), this.item  = varargin{i+1};
                elseif strcmpi(varargin{i}, 'StartTime'); this.startTime  = varargin{i+1};
                elseif strcmpi(varargin{i}, 'EndTime'); this.endTime  = varargin{i+1};
                elseif strcmpi(varargin{i}, 'Quantity'); this.quant  = varargin{i+1};
                elseif strcmpi(varargin{i}, 'TimeFormat'); this.timeFormat  = varargin{i+1};
                end
            end
            this.setTimeFormat();
            suc = 1;
        end
        
        function suc = setTimeFormat(this,tFormat)
            if nargin<2;tFormat = this.timeFormat;end;
            this.startTime.Format = tFormat;
            this.endTime.Format = tFormat;
            suc = 1;
        end
        
        function kn = getKeyName(this)
            kn = datestr(this.startTime, lower(this.timeFormat));
        end
        
    end
    
end