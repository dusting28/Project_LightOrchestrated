function [] = singlePixel(row, column, ax)
        pixelPos = [1876.5,515,35.84, 40.32];
        pixelSpacex = 42.752;
        pixelSpacey = 43.2;

        pixelPos(1) = pixelPos(1) + pixelSpacex * (row-1);
        pixelPos(2) = pixelPos(2) + pixelSpacey * (column-1);

        rectangle('Parent', ax, 'Position', pixelPos, 'FaceColor', 'w', 'EdgeColor', 'none');
end