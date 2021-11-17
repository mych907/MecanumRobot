% resolution 0.1m
% map size 10m X 10m
% 
% map = binaryOccupancyMap(10,10,0.1);
% 
% function []=staticMapMaker(walls)
% % n number of walls
% % each wall has (center point, length, width) in 4x1 matrix
% % walls matrix is 4xn
% % plot the whole static map
% 
% n = length(walls); n = n(2);
% 
% figure(1);
% for i=1:n
%     
% end
% 
% end

%%
close all; clear all; clc;
image1 = imread('factory01.pgm');
imshow(image1);
% make clean floor
len = size(image1);
for i = 1:len(1)
    for j = 1:len(2)
        if image1(i,j) < 10
            image1(i,j) = 0;
        end
    end
end
imageNorm = double(image1)/255;
imageOccupancy = imageNorm; % revert black and white
map2 = occupancyMap(imageOccupancy,1);

figure(1);
show(map2);

% image2 = imread('workspace_ex02.pgm');
% imageNorm = double(image2)/255;
% imageOccupancy = 1 - imageNorm;
% map2 = occupancyMap(imageOccupancy,10);

% ss = stateSpaceSE2;
% sv = validatorOccupancyMap(ss);
% close all;
% map2 = occupancyMap(imageOccupancy,10);
% sv.Map = map2;
% sv.ValidationDistance = 0.01;
% ss.StateBounds = [map2.XWorldLimits; map2.YWorldLimits; [pi pi]];

bounds = [map2.XWorldLimits; map2.YWorldLimits; [pi/2 pi/2]];
ss = stateSpaceDubins(bounds);
ss.MinTurningRadius = 0.1;
sv = validatorOccupancyMap(ss);
sv.Map = map2;
sv.ValidationDistance = 0.01;


planner = plannerRRTStar(ss,sv);
planner.ContinueAfterGoalReached = true; %optimization
planner.MaxIterations = 800000;
planner.MaxConnectionDistance = 1;    %[m]

figure(2);
show(map2)
start = [210, 115, 0]; goal = [278, 340, 0]; %[396, 400, 0];
rng(100,'twister');
%startT = tic();    % start timer
[pthObj,solnInfo] = plan(planner,start,goal);
%endT = toc(startT);    % end timer

hold on; grid on;
plot(start(1), start(2), 'o','MarkerSize',10,'MarkerEdgeColor','red','MarkerFaceColor','magenta');
plot(goal(1), goal(2), 's','MarkerSize',10,'MarkerEdgeColor','k','MarkerFaceColor','b');
plot(solnInfo.TreeData(:,1),solnInfo.TreeData(:,2), '.-'); % tree expansion
plot(pthObj.States(:,1),pthObj.States(:,2),'r-','LineWidth',1); % draw path
% endT
% flag = true;
% while(flag)
%     [pthObj,solnInfo] = plan(planner,start,goal);
%     f = plot(pthObj.States(:,1),pthObj.States(:,2),'r.-','LineWidth',2); % draw path
%     g = plot(pthObj.States(1,1),pthObj.States(1,2),'bo'); % draw now position of robot
%     start = [pthObj.States(2,1),pthObj.States(2,2), 0];
%     drawnow
%     % check arrival state
%     if(start(1) == goal(1))
%         if(start(2) == goal(2))
%             flag = false;
%         end
%     end
%     delete(f)
% end
