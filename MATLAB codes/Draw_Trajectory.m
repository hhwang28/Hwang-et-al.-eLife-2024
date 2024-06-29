
%% Setting

Center_x = 0;
Center_y = 0;
Maze_radius = 8600;
RZ_Inner = 6500;
RZ_Outer = 8000;
PositionofTrialStart.x=X(Index_TrialStart);
PositionofTrialStart.y=Y(Index_TrialStart);
HeadDirection.Start=CenterMonitorDirection(Index_TrialStart) + 9;
ArrowLength=4000;

% High-value zone boundary
arch_inner1=0.843; arch_inner2=1.058;
arch_outer1=0.82; arch_outer2=1.08;
arch_middle1=0.7; arch_middle2=1.2;
[p_Outer_arch, x_Outer_arch, y_Outer_arch]=Draw_Circle(Center_x, Center_y, RZ_Outer, 2, arch_outer1*pi, arch_outer2*pi); p_Outer_arch.LineWidth=1;
[p_Inner_arch, x_Inner_arch, y_Inner_arch]=Draw_Circle(Center_x, Center_y, RZ_Inner, 2, arch_inner1*pi, arch_inner2*pi); p_Inner_arch.LineWidth=1;
RewardZone_arch.x=[x_Outer_arch flip(x_Inner_arch) x_Outer_arch(1)];
RewardZone_arch.y=[y_Outer_arch  flip(y_Inner_arch) y_Outer_arch(1)];

% Low-value zone boundary
house_inner1=1.843; house_inner2=2.058;
house_outer1=1.82; house_outer2=2.08;
house_middle1=1.7; house_middle2=2.2;
[p_Outer_house, x_Outer_house, y_Outer_house]=Draw_Circle(Center_x, Center_y, RZ_Outer, 1, house_outer1*pi, house_outer2*pi); p_Outer_house.LineWidth=1;
[p_Inner_house, x_Inner_house, y_Inner_house]=Draw_Circle(Center_x, Center_y, RZ_Inner, 1, house_inner1*pi, house_inner2*pi); p_Inner_house.LineWidth=1;
RewardZone_house.x=[x_Outer_house flip(x_Inner_house) x_Outer_house(1)];
RewardZone_house.y=[y_Outer_house  flip(y_Inner_house) y_Outer_house(1)];

%% Draw Trajectory

fig=figure;  hold on;

% Draw maze boundary
p_Outline=Draw_Circle(Center_x,Center_y,Maze_radius,4); p_Outline.LineWidth=1;

% Draw Trajectory
for m=1:NumberTrial
    x=X(Index_SceneNavigation.Success & trial==m);
    y=Y(Index_SceneNavigation.Success & trial==m);
    for z=1:length(x)
        p1=plot(x(z),y(z),'.','MarkerSize',30); p1.Color=[.5 .5 .5];
    end
end

% Draw Reward zone
p_arch=plot(RewardZone_arch.x, RewardZone_arch.y); p_arch.Color='r'; p_arch.LineWidth=2; p_arch.LineStyle='-';
p_house=plot(RewardZone_house.x, RewardZone_house.y); p_house.Color='b'; p_house.LineWidth=2; p_house.LineStyle='-';

% Draw start point
p1=plot(PositionofTrialStart.x(n), PositionofTrialStart.y(n),'*'); p1.MarkerSize=20; p1.Color='k';
tempx=X(Index_SceneNavigation.Honeywater_large & trial==m); tempy=Y(Index_SceneNavigation.Honeywater_large & trial==m);
if ~isempty(tempx)
    p_SceneNavigation_end=plot(tempx(end),tempy(end),'r.'); p_SceneNavigation_end.MarkerSize=20;
end

% Draw arrow (head direction)
xtemp = (PositionofTrialStart.x(n));
ytemp = (PositionofTrialStart.y(n));
xend = (PositionofTrialStart.x(n) + ArrowLength * cos(HeadDirection.Start(n)*pi/180));
yend = (PositionofTrialStart.y(n) + ArrowLength * sin(HeadDirection.Start(n)*pi/180));
GetArrow([xtemp ytemp],[xend yend],30,'EdgeColor','k','FaceColor','k','Width',6,'tipangle',20)

g=gca;
g.YDir='rev';
g.XLim=[-10000 10000]; g.YLim=[-10000 10000];
g.XTick=[]; g.YTick=[];
axis square; axis off
camroll(-9);
