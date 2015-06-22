function [ ] = showPrecipData( allImgs )
%SHOWPRECIPDATA Summary of this function goes here
%   Detailed explanation goes here
% Create a figure and axes
f = figure('Visible','off');
maxP = max(max(allImgs{1}));
imagesc(allImgs{1},[0 maxP]);
colorbar;

% Create slider
sld = uicontrol('Style', 'slider',...
    'Min',0,'Max',7100,'Value',10,'SliderStep',[1 10],...
    'Position', [0 0 800 20],...
    'Callback', @surfzlim); 

% Make figure visble after adding all components
f.Visible = 'on';
% This code uses dot notation to set properties. 
% Dot notation runs in R2014b and later.
% For R2014a and earlier: set(f,'Visible','on');

function surfzlim(source,callbackdata)
    ind = ceil(source.Value);
    maxP = max(max(allImgs{ind}));
    imagesc(allImgs{ind},[0 maxP]);
    source.Value
    colorbar;
end

end

