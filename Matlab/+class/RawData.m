classdef RawData < handle
    
    
    properties
        fileDir = '../Files from Rob/';
        % fileName = 'RCC - Reese network by line - REP - 20170725';
        fileName = 'REPORT - ITEM DEMAND DETAIL 20170725 reese';
        filePath
        sheetNames
        head
        txt
        data
    end
    
    
    methods
        function this = RawData(dir,name)
            if nargin>=1;this.fileDir = dir;end
            if nargin>=2;this.fileName = name;end;
            this.filePath = [this.fileDir,this.fileName,'.xlsx'];
        end
        
        function readFileSheet(this)
            [~,this.sheetNames]=xlsfinfo(this.filePath);
        end
        
        function readSheet(this, name, range)
%             range = 'A1:Y2058';
            [dataRaw,txtRaw] = xlsread(this.filePath, name, range);
            
            this.data = zeros(size(txtRaw,1)-1,size(txtRaw,2));
            
            for i=14:1:size(txtRaw,2)
                this.data(:,i) = dataRaw(:,i-13);
            end
            
            this.head = txtRaw(1,:);
            this.txt = txtRaw(2:end,:);
            disp(['File: ,',this.filePath]);
            disp(['Read sheet: ', name,'...success!']);
        end
        
        function idx = getSheetIdx(this, name)
            import fun.findStringInCellArray
            idx = findStringInCellArray(this.sheetNames, name);
        end
        
        function lineGroup = convertData2Lines(this)
            import class.LineGroup;
            lineGroup = LineGroup();
            lineGroup.getLinesFromRawData(this);
        end
    end
    
end