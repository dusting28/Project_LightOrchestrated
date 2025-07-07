function [] = drawLine(location, ax)
        x0 = 1735;
        mm_to_pixel = 4.3;

        pixelPos = [x0 - location*mm_to_pixel, 561, 35.84, 340];
        rectangle('Parent', ax, 'Position', pixelPos, 'FaceColor', 'w', 'EdgeColor', 'none');
        pixelPos = [x0 - location*mm_to_pixel, 1070, 35.84, 300];
        rectangle('Parent', ax, 'Position', pixelPos, 'FaceColor', 'w', 'EdgeColor', 'none');
        pixelPos = [x0 - location*mm_to_pixel, 100, 35.84, 300];
        rectangle('Parent', ax, 'Position', pixelPos, 'FaceColor', 'w', 'EdgeColor', 'none');
end

