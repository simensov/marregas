% This function takes in an ax = gca object and improves fit in plots
function improveFigFit(ax)
    outerpos = ax.OuterPosition;
    ti = ax.TightInset; 
    left = outerpos(1) + ti(1);
    bottom = outerpos(2) + ti(2);
    ax_width = outerpos(3) - ti(1) - ti(3);
    ax_height = outerpos(4)*0.95 - ti(2) - ti(4);
    ax.Position = [left bottom ax_width ax_height];
end