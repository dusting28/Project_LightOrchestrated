function [centroid] = findGreenDot(image)
    % Convert to HSV
    hsvImg = rgb2hsv(image);
    H = hsvImg(:,:,1);
    S = hsvImg(:,:,2);
    V = hsvImg(:,:,3);

    % Green dot HSV thresholds
    greenMask = H > 0.18 & H < 0.28 & ...
                S > 0.3  & S < 0.70 & ...
                V > 0.6;

    % Remove small noise
    greenMask = bwareaopen(greenMask, 30);
    greenMask = imfill(greenMask, 'holes');

    % Get region properties
    stats = regionprops(greenMask, 'Centroid', 'Area', 'Eccentricity', 'MajorAxisLength');

    if isempty(stats)
        warning("No green dot detected.");
        centroid = [NaN, NaN];
        return;
    end

    % Filter based on circularity and size (expect ~15 px diameter)
    expectedDiameter = 14;
    areaRange = [pi*(expectedDiameter/2)^2 * 0.25, pi*(expectedDiameter/2)^2 * 1.7];  % [~105, ~260]
    eccThresh = 0.92;  % circular shapes

    isDot = arrayfun(@(s) ...
        s.Area > areaRange(1) && s.Area < areaRange(2) && ...
        s.Eccentricity < eccThresh, stats);

    if ~any(isDot)
        warning("No valid green dot found after filtering.");
        centroid = [NaN, NaN];
        return;
    end

    % Use the largest valid circular blob
    validStats = stats(isDot);
    [~, idx] = max([validStats.Area]);
    centroid = validStats(idx).Centroid;
end