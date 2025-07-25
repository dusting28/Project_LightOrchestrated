function [] = analogPixel(row, column, magnitude, ax)
        pixelPos = [255,915,35.84, 40.32];
        pixelSpacex = 42.752;
        pixelSpacey = 43.2;

        pixelPos(1) = pixelPos(1) + pixelSpacex * (row-1);
        pixelPos(2) = pixelPos(2) - pixelSpacey * (column-1);

        color = [magnitude, magnitude, magnitude];
        rectangle('Parent', ax, 'Position', pixelPos, 'FaceColor', color, 'EdgeColor', 'none');
end