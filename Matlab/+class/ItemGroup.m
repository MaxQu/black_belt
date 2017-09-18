classdef ItemGroup < handle
    
    
    properties
        name
        items_ %
        items %key map
        itemNum = 0;
        itemNames ={};
    end
    
    methods
        function this = ItemGroup(varargin)
            import class.LineItem;
            if length(varargin)==1;varargin = varargin{1};end;
            this.items = containers.Map('KeyType','char', 'ValueType','any');
            this.items_ = LineItem();
            this.setProp(varargin);
        end
        
        function suc = setProp(this,varargin)
            if length(varargin)==1;varargin = varargin{1};end;
            for i = 1:2:length(varargin)
                if  strcmpi(varargin{i}, 'Name'), this.name  = varargin{i+1};
                elseif strcmpi(varargin{i}, 'Items'); this.items_  = varargin{i+1}; this.setItemKeyMap();
                end
            end
            suc = 1;
        end
        
                
        function suc = setItemKeyMap(this)
            this.getItemNum();
            for i =1:1:this.itemNum
                this.items(this.items_(i).getKeyName()) = this.items_(i);
            end
            this.getItemNames();
            suc = 1;
        end
        
        function suc = addItem(this,newItem)
            len = length(newItem);
            for i=1:1:len
                this.items_(this.itemNum+i,1) = newItem(i);
                newItemName = newItem(i).getKeyName();
                if this.items.isKey(newItemName)
                    error('the line key already exists, cannot add new line');
                end
                this.items(newItemName) = this.items_(this.itemNum+1,1);
            end
            this.getItemNum();
            this.getItemNames();
            suc = 1;
        end
        
        function suc = removeItem(this,itemSku)
            if ~iscell(itemSku);itemNameCell = cell(1,1);itemNameCell{1}=itemSku;end;
            for i=1:1:length(itemNameCell);
                idxItem = this.findItemIdxUsingKey(itemNameCell{i});
                isItem = ~isempty(idxItem);
                if isItem
                    this.items.remove(this.items_(idxItem).getKeyName());
                    this.items_(idxItem) = [];
                    this.getItemNum();
                    this.getItemNames();
                end
            end
            suc = 1;
        end
        
        function idxAfterCheck = findItemIdxUsingKey(this,keyName)
           idx = [];
           for i=1:1:this.itemNum;
               if strfind(this.itemNames{i},keyName);
                   idx = [idx;i];
               end
           end
           
           if length(idx)>1;
               %check if one of the long name is exactly the key
               idxAfterCheck = [];
               for i=1:1:length(idx);
                   if strcmp(this.itemNames{idx(i)},keyName)
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
        
        function n = getItemNum(this)
            this.itemNum = length(this.items_);
            n = this.itemNum;
        end
        
        function ns = getItemNames(this)
            this.itemNames = cell(this.itemNum,1);
            for i=1:1:this.itemNum
                this.itemNames{i} = this.items_(i).sku;
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
%             lineKey = this.name(1:min(15,length(this.name)));
            lineKey = this.name;

        end
    end
    
end