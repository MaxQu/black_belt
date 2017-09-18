%chloe's black belt project, in progress, in collabration
clearvars -except rawData;
close all;
import fun.*;
import class.*;

if ~exist('rawData','var');
    rawData = RawData('../Files_from_Rob/', 'REPORT - ITEM DEMAND DETAIL 20170725 reese');
    rawData.readSheet('Item Demand Original','A1:Y2058');
end
%%
lg = Company('Name','Reese');
lg.getDemandInfoFromRawData(rawData);
lg.setMonthlyStatus();
% line1 = lg.getLine('1003 LINE 1'); %test

%%
%test
% lg.lines('1003 LINE 12').removeItem('587398000');
% lg.lines('1003 LINE 12').addItem(LineItem('Item','587398000'));
% lg.lines('1003 LINE 1').setMonthlyStatus();