classdef PlanGroup < handle
    
    properties
       name
       plans  %prodPlan key map
       plans_ %prodPlan obj vec
       planNum = 0; %total prodPlan num
       planNames = {}; %all prodPlan Names
    end
    
    
    methods
        function this = PlanGroup(varargin)
            import class.Plan;
            if length(varargin)==1;varargin = varargin{1};end;
            this.plans = containers.Map('KeyType','char', 'ValueType','any');
            this.plans_ = Plan();
            this.setProp(varargin);
        end
        
        function suc = setProp(this,varargin)
            if length(varargin)==1;varargin = varargin{1};end;
            for i = 1:2:length(varargin)
                if  strcmpi(varargin{i}, 'name'); this.name  = varargin{i+1};
                elseif strcmpi(varargin{i}, 'Plans'); this.plans_  = varargin{i+1}; this.setPlanKeyMap();
                end
            end
            suc = 1;
        end
        
        function suc = addPlan(this,newDemPlan)
            len = length(newDemPlan);
            for i=1:1:len
                this.plans_(this.planNum+i,1) = newDemPlan(i);
                newItemName = newDemPlan(i).getKeyName();
                if this.plans.isKey(newItemName)
                    error('the line key already exists, cannot add new line');
                end
                this.plans(newItemName) = this.plans_(this.planNum+1,1);
            end
            this.getPlanNum();
            this.getPlanNames();
            suc = 1;
        end
        
        function suc = removePlan(this,planKey)
            if ~iscell(planKey);demPlanNameCell = cell(1,1);demPlanNameCell{1}=planKey;end;
            for i=1:1:length(demPlanNameCell);
                idxDemPlan = this.findPlanIdxUsingKey(demPlanNameCell{i});
                isDemPlan = ~isempty(idxDemPlan);
                if isDemPlan
                    this.plans.remove(this.plans_(idxDemPlan).getKeyName());
                    this.plans_(idxDemPlan) = [];
                    this.getPlanNum();
                    this.getPlanNames();
                end
            end
            suc = 1;
        end
        
        function n = getPlanNum(this)
            this.planNum = length(this.plans_);
            n = this.planNum;
        end
        
        function ns = getPlanNames(this)
            this.planNames = cell(this.planNum,1);
            for i=1:1:this.planNum
                this.planNames{i} = this.plans_(i).getKeyName();
            end
            ns = this.planNames;
        end
        
        function dt = getCycles(this)
            dt = datetime;
            for i=1:1:this.planNum
               dt(i,1) = this.plans_(i).startTime; 
            end
            dt = sort(dt);
            dt.Format = this.plans_(i).startTime.Format;
        end
        
        function idxAfterCheck = findPlanIdxUsingKey(this,keyName)
           idx = [];
           for i=1:1:this.planNum;
               if strfind(this.planNames{i},keyName);
                   idx = [idx;i];
               end
           end
           
           if length(idx)>1;
               %check if one of the long name is exactly the key
               idxAfterCheck = [];
               for i=1:1:length(idx);
                   if strcmp(this.planNames{idx(i)},keyName)
                       idxAfterCheck = [idxAfterCheck;idx(i)];
                   end
               end
               if isempty(idxAfterCheck);idxAfterCheck= idx;end
           else
               idxAfterCheck = idx;
           end
           
           if length(idxAfterCheck)>1;
               error('key is not unique');
           end
        end
        
        function suc = setPlanKeyMap(this)
            this.getPlanNum();
            for i =1:1:this.planNum
                this.plans(this.plans_(i).getKeyName()) = this.plans_(i);
            end
            this.getPlanNames();
            suc = 1;
        end
    
    end
    
end