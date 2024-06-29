
%% Index

% Index for trial start - first
NumberIndex=length(trial);
for i=2:NumberIndex
    if trial(i) == 1
        Index_TrialStart(1)=i;
        break;
    end
end
m=2;
for i=2:NumberIndex
    if (trial(i-1) ~= trial(i)) && trial(i) ~= 1
        Index_TrialStart(m)=i; m=m+1;
    elseif Flag_help(i) ~= Flag_help(i-1) && Flag_help(i) == 0
        Index_TrialStart(m-1)=i;
        HelpTrial(trial(i))=1;
    end
end
Index_FirstTrialStart=151;
m=2;
for i=2:NumberIndex
    if (trial(i-1) ~= trial(i)) && trial(i) ~= 1
        Index_FirstTrialStart(m)=i; m=m+1;
    end
end

% Index for reward zone arrival
Index_RZarrive=[];
RewardType=[];
for i=2:NumberIndex
    if RewardZone_Arrival(i-1) ~= RewardZone_Arrival(i) && RewardZone_Arrival(i) ~= 0 && RewardZone_Arrival(i-1) ~= 2
        for k=1:length(Index_TrialStart)
            if k<length(Index_TrialStart)
                if i > Index_FirstTrialStart(k) && i < Index_FirstTrialStart(k+1)
                    Index_RZarrive(k)=i;
                    RewardType(k)=RewardZone_Arrival(i);
                    break;
                end
            elseif k==length(Index_TrialStart)
                Index_RZarrive(k)=i;
                RewardType(k)=RewardZone_Arrival(i);
                break;
            end
        end
    end
end
Index_RZarrive(Index_RZarrive==0)=Index_TrialStart(find(Index_RZarrive==0)+1)-1;
Index_TrialStart=Index_TrialStart(1:length(Index_RZarrive));
NumberTrial=length(Index_TrialStart);

% Index for trial end
m=1;
for i=2:NumberIndex
    if trial(i-1) ~= trial(i) && trial(i) ~= 1
        Index_TrialEnd(m)=i-1; m=m+1;
    end
end
if length(Index_TrialEnd) < length(Index_RZarrive)
    Index_TrialEnd(end+1)=NumberIndex;
end
Trial_excludeVoid=1:length(Index_TrialStart);
Trial_IncludeVoid=1:NumberTrial;

% Index for navigation epoch
Index_SceneNavigation.Success=zeros(NumberIndex,1);
Index_SceneNavigation.Failed=zeros(NumberIndex,1);
Index_NonNavigation=zeros(NumberIndex,1);

for m=1:NumberIndex
    if trial(m)<=length(Index_TrialStart) && trial(m)>0
        i=Trial_IncludeVoid(trial(m));
        j=find(Trial_excludeVoid==i);
        if ~isnan(i)
            if sum(m >= Index_TrialStart & m < Index_RZarrive)
                Index_SceneNavigation.Success(m,1)=1;
            elseif sum(m >= Index_RZarrive & m < Index_TrialEnd)
                Index_NonNavigation(m,1)=1;
            end            
        elseif isnan(i)
            if sum(m >= Index_TrialStart & m < Index_RZarrive)
                Index_SceneNavigation.Failed(m,1)=1;
            end
        end
    end
end

%% Setting

% Departure circle
Center_x = 0;
Center_y = 0;
Maze.Start_1000.r = 1000;
[p_Start_1000_arch, x_Start_1000_arch, y_Start_1000_arch]=Draw_Circle(Center_x,Center_y,Maze.Start_1000.r,2, 0, 2*pi); close all;
Flag_start_1000=~inpolygon(X, Y, [x_Start_1000_arch x_Start_1000_arch(1)], [y_Start_1000_arch y_Start_1000_arch(1)]);

% Variable setting
temp=[]; tempcell=[]; tempdistance=[]; tempdistnorm=[]; tempdistnorm_index=[]; tempstart=[];
tempnorm_pine=[]; tempnorm_leaf=[]; tempnorm_mount=[]; tempnorm_wind=[]; tempnorm_sea=[]; tempnorm_mush=[];
tempfin_pine=[]; tempfin_leaf=[]; tempfin_mount=[]; tempfin_wind=[]; tempfin_sea=[]; tempfin_mush=[];
tempsem_pine=[]; tempsem_leaf=[]; tempsem_mount=[]; tempsem_wind=[]; tempsem_sea=[]; tempsem_mush=[];
UEtoMeter=10600;
pine=1; leaf=1; mount=1; wind=1; sea=1; mush=1;

% Figure window
f1=figure; f1.Position=[0 0 700 800];hold on;
f2=figure; f2.Position=[0 0 700 800];hold on;
f3=figure; f3.Position=[0 0 700 800];hold on;
f4=figure; f4.Position=[0 0 700 800];hold on;
f5=figure; f5.Position=[0 0 700 800];hold on;
f6=figure; f6.Position=[0 0 700 800];hold on;

%% Scene Direction Change

for i=1:NumberTrial
    tempcondition=find(trial==i & Index_SceneNavigation.Success & Flag_start_1000==0);
    temp=CenterMonitorDirection(tempcondition)+9;
    tempindex=1:length(temp);
    deltax=(X(tempcondition));
    deltay=(Y(tempcondition));
    tempdistance{i}=cumsum(sqrt(diff(deltax).^2+diff(deltay).^2)/UEtoMeter);
    tempdistnorm{i}=tempdistance{i}/max(tempdistance{i});
    temp(1)=[];
    tempnegative=temp; neg=0;
    tempstart=find(tempdistnorm{i}>0,1);
    for n=2:length(temp)
        if temp(n-1)<14 & temp(n)>360
            neg=1;
        end
        if neg==1
            tempnegative(n)=-(360-temp(n));
        else
            tempnegative(n)=temp(n);
        end      
    end 
    
    for n=1:20
        if temp(1)<50 % Start direction SE
            tempnorm_pine(n,pine)=nanmean(tempnegative(find((0.05*(n-1))<=tempdistnorm{i} & tempdistnorm{i}<(0.05*n))));
        elseif temp(1)>80 & temp(1)<100 % Start direction S
            tempnorm_leaf(n,leaf)=nanmean(tempnegative(find((0.05*(n-1))<=tempdistnorm{i} & tempdistnorm{i}<(0.05*n))));
        elseif temp(1)>130 & temp(1)<140 % Start direction SW
            tempnorm_mount(n,mount)=nanmean(tempnegative(find((0.05*(n-1))<=tempdistnorm{i} & tempdistnorm{i}<(0.05*n))));
        elseif temp(1)>220 & temp(1)<230 % Start direction NW
            tempnorm_wind(n,wind)=nanmean(tempnegative(find((0.05*(n-1))<=tempdistnorm{i} & tempdistnorm{i}<(0.05*n))));
        elseif temp(1)>265 & temp(1)<275 % Start direction N
            tempnorm_sea(n,sea)=nanmean(tempnegative(find((0.05*(n-1))<=tempdistnorm{i} & tempdistnorm{i}<(0.05*n))));
        else % Start direction NE
            tempnorm_mush(n,mush)=nanmean(tempnegative(find((0.05*(n-1))<=tempdistnorm{i} & tempdistnorm{i}<(0.05*n))));
        end
    end
    
    if temp(1)<50
        figure(f1);
        p1=plot(tempdistance{i}/max(tempdistance{i}),(tempnegative),'Color',[225 142 21]./255,'LineWidth',4);
        plot(0,tempnegative(tempstart),'.','MarkerSize',35,'MarkerEdgeColor',[225 142 21]./255);
        pine=pine+1;
    elseif temp(1)>80 & temp(1)<100
        figure(f2);
        p2=plot(tempdistance{i}/max(tempdistance{i}),(tempnegative),'Color',[250 80 189]./255,'LineWidth',4);
        plot(0,tempnegative(tempstart),'.','MarkerSize',35,'MarkerEdgeColor',[250 80 189]./255);
        leaf=leaf+1;
    elseif temp(1)>130 & temp(1)<140
        figure(f3);
        p3=plot(tempdistance{i}/max(tempdistance{i}),(tempnegative),'Color',[178 68 68]./255,'LineWidth',4);
        plot(0,tempnegative(tempstart),'.','MarkerSize',35,'MarkerEdgeColor',[178 68 68]./255);
        mount=mount+1;
    elseif temp(1)>220 & temp(1)<230
        figure(f4);
        p4=plot(tempdistance{i}/max(tempdistance{i}),(tempnegative),'Color',[0 214 209]./255,'LineWidth',4);
        plot(0,tempnegative(tempstart),'.','MarkerSize',35,'MarkerEdgeColor',[0 214 209]./255);
        wind=wind+1;
    elseif temp(1)>265 & temp(1)<275
        figure(f5);
        p5=plot(tempdistance{i}/max(tempdistance{i}),(tempnegative),'Color',[53 86 164]./255,'LineWidth',4);
        plot(0,tempnegative(tempstart),'.','MarkerSize',35,'MarkerEdgeColor',[53 86 164]./255);
        sea=sea+1;
    elseif temp(1)>310 & temp(1)<320 %
        figure(f6);
        p6=plot(tempdistance{i}/max(tempdistance{i}),(tempnegative),'Color',[67 234 0]./255,'LineWidth',4);
        plot(0,tempnegative(tempstart),'.','MarkerSize',35,'MarkerEdgeColor',[67 234 0]./255);
        mush=mush+1;
    end
end

%% Labeling
for cnt=1:6
    if cnt==1; figure(f1);
    elseif cnt==2; figure(f2);
    elseif cnt==3; figure(f3);
    elseif cnt==4; figure(f4);
    elseif cnt==5; figure(f5);
    elseif cnt==6; figure(f6); end
    
    ylim([-360 360]); xlim([0 1]);
    yticks([]); xticks([]);
    yticks([-360:180:360]); yticklabels({'-360 ','  -180 ','  0 ','  180 ','  360 '});
    g=gca; g.FontSize=60;
    box on; ax=gca; ax.LineWidth=8;
end
