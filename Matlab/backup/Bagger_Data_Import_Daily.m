%%import data from bagger excel spread sheet

clear all;close all;

filedir = 'Data/';
figdir = 'pics/';
figsave = 0;
% filename = 'Bagger 13 Data new';
% filename = 'Bagger 13 Data - Jan 2017';
% filename = 'Bagger 13 Data - Feb 14 2017';
% filename = 'Bagger 13 Data - Mar 22 2017';
% filename = 'Bagger 5 Data - 20188';
% filename = '4.14 quality check data';
% filename = '4.21-5.2';
% filename = '5.9-5.19';
% filename = 'Bagger 13 5.2 to 5.8';
% filename = 'Bagger 13 - May 26 to June 5';
% filename = 'Bagger 13 - June 5 to June 12';
% filename = 'Bagger 13 - June 13 - June 21';
filename = 'Bagger 13 - June 22- July 5';


filepath = [filedir,filename,'.xls'];
[~,rawsheetnames]=xlsfinfo(filepath);
data={};
sheetnamesidx = ones(length(rawsheetnames),1);
for i=1:1:length(rawsheetnames)
    if strncmp(rawsheetnames{1,i},'Sheet',5);
        sheetnamesidx(i) = 0;
    end
end
sheetnames = rawsheetnames(sheetnamesidx==1);

%%
for i=1:1:length(sheetnames)
% for i=1:1:2;
    sheet_name = sheetnames{i};
    disp(['i = ',num2str(i),', sheetname = ', sheet_name]);
    [data_raw,txt_raw,~] = xlsread(filepath,sheet_name);
    
    max_search_depth = 100;
    
    %check header row alignment
    
    if ~strncmp(char(txt_raw{1,1}),'Shift',5);
        header_row = 0;

        for rowi=1:1:max_search_depth
            if strncmp(char(txt_raw{rowi,1}),'Shift',5)
               header_row = rowi-1;
               break;
            end
            if rowi==max_search_depth
                error('can not align head row');
            end
        end
        txt_raw(1:header_row,:) = [];
        if isnan(data_raw(2,2))
            data_raw(1:header_row,:)=[];
        end
        disp('check header row alignment ... done');
    end
    
    data_head_row_start = 1;
    data_head_row_end = 2;
    data_row_start = 0;
    data_row_end = 0;
    
    for k=1:1:max_search_depth

        if strncmp(char(txt_raw{k,1}),'Bag #',5);
            data_row_start =k;
        end

       if strncmp(char(txt_raw{k,1}), 'Bag 10',6);
           data_row_end = k;
           break
       end
    end

    num_data_row = data_row_end-data_row_start-1;
    
    if data_row_end == 0 || data_row_start >= max_search_depth-10 ||num_data_row ~= 10
       error('data row search error'); 
    end

    
    
    max_search_width = size(data_raw,2);
    num_data_col = 0;
    for k=2:1:max_search_width
        

        if isnan(data_raw(data_row_start,k))
           num_data_col = k-2;
           break;
        elseif k==max_search_width
           num_data_col = k-1;
           break
        end

        
        
    end
    
    if num_data_col ==0
       error('data col search error'); 
    end
    
    if i==1 || ~exist('data_head','var');
        data_head = {txt_raw{data_row_start,1},'check #','time','weights','vacant'...
            txt_raw(1,1),txt_raw(1,3),txt_raw(1,5),txt_raw(1,7),...
            txt_raw(2,1),txt_raw(2,3),txt_raw(2,5),txt_raw(2,7),...
            'sheet date','sheet shift'};
    end
    
    data_sheet_row = num_data_row * num_data_col;
    data_sheet=cell(data_sheet_row, size(data_head,2));
    % data_sheet(1,:)=data_head;
    %%
    %check specific
    for j=1:1:num_data_col
        data_sheet((j-1)*num_data_row+1:j*num_data_row,1) = txt_raw(data_row_start+2:data_row_end,1);
        data_sheet((j-1)*num_data_row+1:j*num_data_row,2) = num2cell(repmat(data_raw(data_row_start,j+1),[num_data_row,1]));
        data_sheet((j-1)*num_data_row+1:j*num_data_row,3) = repmat(cellstr(datestr(data_raw(data_row_start+1,j+1),'HH:MM:SS')),[num_data_row,1]);
        data_sheet((j-1)*num_data_row+1:j*num_data_row,4) = num2cell(data_raw(data_row_start+2:data_row_end,j+1));
        
    end
    
    %tab specific
%     data_sheet(1:num_data_row,1:num_data_col)=num2cell(data_raw(data_row_start+2:data_row_end-1, 1:num_data_col));
    data_sheet(1:data_sheet_row,6)=num2cell(repmat(txt_raw(1,2),[data_sheet_row,1]));
    data_sheet(1:data_sheet_row,7)=cellstr(datestr(repmat(data_raw(1,4),[data_sheet_row,1])-1, 2, 1900));
    if ~isnan(data_raw(1,6));
    data_sheet(1:data_sheet_row,8)=num2cell(repmat(data_raw(1,6),[data_sheet_row,1]));
    else
    data_sheet(1:data_sheet_row,8)=num2cell(repmat(txt_raw(1,6),[data_sheet_row,1]));    
    end
    data_sheet(1:data_sheet_row,9)=num2cell(repmat(txt_raw(1,8),[data_sheet_row,1]));
    data_sheet(1:data_sheet_row,10)=num2cell(repmat(data_raw(2,2),[data_sheet_row,1]));
    data_sheet(1:data_sheet_row,11)=num2cell(repmat(data_raw(2,4),[data_sheet_row,1]));
    data_sheet(1:data_sheet_row,12)=num2cell(repmat(data_raw(2,6),[data_sheet_row,1]));
    data_sheet(1:data_sheet_row,13)=num2cell(repmat(data_raw(2,8),[data_sheet_row,1]));
    sheetnamesepidx = strfind(sheet_name,' ');
    data_sheet(1:data_sheet_row,14)=num2cell(repmat({sheet_name(1:sheetnamesepidx-1)},[data_sheet_row,1]));
    data_sheet(1:data_sheet_row,15)=num2cell(repmat({sheet_name(sheetnamesepidx+1:length(sheet_name))},[data_sheet_row,1]));

%     data_sheet(1:data_sheet_row,14)=num2cell(repmat({sheet_name(1:length(sheet_name)-4)},[data_sheet_row,1]));
%     data_sheet(1:data_sheet_row,15)=num2cell(repmat({sheet_name(length(sheet_name)-2:length(sheet_name))},[data_sheet_row,1]));

    %%
    data=[data;data_sheet];

end

data=[data_head;data];

%%
% fileoutput=[filedir,filename,' combined.xls'];
% xlwrite(fileoutput, data);

% fileoutput=[filedir,filename,' combined.txt'];
% export_cell_to_txt(fileoutput,data);