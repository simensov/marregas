%%
% This file creates a plot of the surface elevation using the ITTC spectra
% TMR4240, Fall 2019. Created by Simen Sem Oevereng

% Constants, both given and needed for plot
H_significant = 2.5;            % Significant wave height
T_peak        = 9.0;            % Peak period from wind generated waves
omega_peak    = 2.0*pi/T_peak;  % Peak frequency from period given
omega_low     = 0.2;            % Lowest frequency to be plotted
omega_high    = 3.0*omega_peak; % Largest frequency to be plotted
g_accel       = 9.81;           % Gravitational acceleration
PLT_NUM       = 150;            % Number of plots
dw            = (omega_high-omega_low)/PLT_NUM; % Increment in frequency
w_range       = omega_low:dw:omega_high;        % All frequencies
x_max         = 5000;           % Largest x-value in movie
x_range       = 0:0.5:x_max;    % Range of all x-values used
t_final       = 30;             % Time used for plotting
dt            = 0.2;
t_range       = 0:dt:t_final;  % Range of time instances

% Get amplitudes from ITTC spectra
A = 0.31 * H_significant^2 * omega_peak^4;
B = 1.25 * omega_peak^4;
ampl = zeros(1,length(w_range));

% Create all random variables and wave numbers in the same loop
phi = zeros(1,length(w_range));
k = zeros(1,length(w_range));

for q = 1:length(w_range)
    S = (A / w_range(q)^5) * exp(-B / w_range(q)^4);
    ampl(q) = sqrt(2 * S * dw); 
    phi(q) = unifrnd(0,2*pi);
    k(q) = w_range(q)^2 / g_accel;
end

% Create a figure to take snapshots of in order to create a movie
fig = figure;
grid on
axis([0 5000 -5 5])
xlabel('x-coordinate [m]');
ylabel('Surface elevation [m]');
set(gca,'nextplot','replacechildren');
filename = 'elevation.gif';

% Pre-allocating surface elevation per wave component and entire elevation
z_j = zeros(1,length(w_range)); 
z = zeros(1,length(x_range));

% For each time instance, go through wave elevation for all x-values, and
% calculate elevation per frequency component q. Then sum those elevation
% components in order to get the entire elevation of on time instance.
for tC = 1:length(t_range)
    t = t_range(tC);
    
    for i = 1:length(x_range)
        for q = 1:length(w_range)
            z_j(q) = ampl(q) * cos(w_range(q) * t - k(q) * x_range(i) + phi(q));
        end
        z(i) = sum(z_j);
    end
    plot(x_range,z);        % Plot elevation at t over entire horizontal range
    text(x_max/2.5,4,sprintf('time = %.2f s',t)) % Add timestamp to figure
    F(tC) = getframe(fig);  % Create snapshot from current figure  
end

% Create a gif
movie2gif(F,filename,'Delay',0);

movie(F,1,1); % Create movie from frames in F, play it once at 1 fps live
disp('Done!');

%%

% The following two functions has been used in order to create a GIF
% of the surface elevation. It is created by Nicolae Cindea, and was found
% at mathworks.com/matlabcentral/fileexchange/17463-movie-to-gif-converter

function [X, map] = aRGB2IND(RGB, nc)
    % Convert RGB image to indexed image
    % More or less has the same syntax as rgb2ind 
    if (nargin < 2)
        nc = 256;
    end
    m = size(RGB, 1);
    n = size(RGB, 2);
    X = zeros(m, n);
    map(1,:) = RGB(1, 1, :)./nc;
    for i = 1:m
        for j = 1:n
            RGBij = double(reshape(RGB(i,j,:), 1, 3)./nc);
            isNotFound = true;
            k = 0;
            while isNotFound && k < size(map, 1)
                k = k + 1;
                if map(k,:) ==  RGBij
                    isNotFound = false;
                end
            end
            if isNotFound
                map = [map; RGBij];
            end
            X(i,j) = double(k);
        end
    end
    map = double(map);
end

function movie2gif(mov, gifFile, varargin)
    % ==================
    % Matlab movie to GIF Converter.
    %
    % Syntax: movie2gif(mov, gifFile, prop, value, ...)
    % =================================================
    % The list of properties is the same like for the command 'imwrite' for the
    % file format gif:
    %
    % 'BackgroundColor' - A scalar integer. This value specifies which index in
    %                     the colormap should be treated as the transparent
    %                     color for the image and is used for certain disposal
    %                     methods in animated GIFs. If X is uint8 or logical,
    %                     then indexing starts at 0. If X is double, then
    %                     indexing starts at 1.
    %
    % 'Comment' - A string or cell array of strings containing a comment to be
    %             added to the image. For a cell array of strings, a carriage
    %             return is added after each row.
    %
    % 'DelayTime' - A scalar value between 0 and 655 inclusive, that specifies
    %               the delay in seconds before displaying the next image.
    %
    % 'DisposalMethod' - One of the following strings, which sets the disposal
    %                    method of an animated GIF: 'leaveInPlace',
    %                    'restoreBG', 'restorePrevious', or 'doNotSpecify'.
    %
    % 'LoopCount' - A finite integer between 0 and 65535 or the value Inf (the
    %               default) which specifies the number of times to repeat the
    %               animation. By default, the animation loops continuously.
    %               For a value of 0, the animation will be played once. For a
    %               value of 1, the animation will be played twice, etc.
    %
    % 'TransparentColor' - A scalar integer. This value specifies which index
    %                      in the colormap should be treated as the transparent
    %                      color for the image. If X is uint8 or logical, then
    %                      indexing starts at 0. If X is double, then indexing
    %                      starts at 1
    %
    % *************************************************************************
    % Copyright 2007-2013 by Nicolae Cindea.
    if (nargin < 2)
        error('Too few input arguments');
    end
    if (nargin == 2)
        frameNb = size(mov, 2);
        isFirst = true;
        h = waitbar(0, 'Generate GIF file...');
        for i = 1:frameNb
            waitbar((i-1)/frameNb, h);
            [RGB, ~] = frame2im(mov(i));
            if (exist('rgb2ind', 'file'))
                [IND, map] = rgb2ind(RGB,256);
            else
                [IND, map] = aRGB2IND(RGB);
            end
            if isFirst
                imwrite(IND, map, gifFile, 'gif');
                isFirst=false;
            else
                imwrite(IND, map, gifFile, 'gif', 'WriteMode', 'append');
            end
        end
        close(h);
    end
    if (nargin > 2)
        h = waitbar(0, 'Generate GIF file...');
        frameNb = size(mov, 2);
        isFirst = true;
        for i = 1:frameNb
            waitbar((i-1)/frameNb, h);
            [RGB, ~] = frame2im(mov(i));
            if (exist('rgb2ind', 'file'))
                [IND, map] = rgb2ind(RGB,256);
            else
                [IND, map] = aRGB2IND(RGB);
            end
            if isFirst
                args = varargin;
                imwrite(IND, map, gifFile, 'gif', args{:});
                isFirst=false;

                % supress 'LoopCount' option from the args!!
                args = varargin;
                l = length(args);

                posLoopCount = 0;
                for ii = 1:l
                    if(ischar(args{ii}))
                        if strcmp(args{ii}, 'LoopCount')
                            posLoopCount = ii;
                        end
                    end
                end
                if (posLoopCount)
                    args = {args{1:posLoopCount-1}, args{posLoopCount+2:end}};
                end

            else
                imwrite(IND, map, gifFile, 'gif', 'WriteMode', 'append', ...
                    args{:});
            end
        end
        close(h);
    end

end
