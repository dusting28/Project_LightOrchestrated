function [analytic_force] = EM_force(coil_radius,coil_height,magnet_radius,magnet_height,gap,turns,current)
    permiability = 4*pi*10^(-7);
    magnetization = 923*(10^3);
    coil_radius = coil_radius/1000;
    coil_height = coil_height/1000;
    magnet_radius = magnet_radius/1000;
    magnet_height = magnet_height/1000;
    gap = gap/1000;
    d_centers = magnet_height/2+coil_height/2+gap;
    n = turns./coil_height;
    mult = (permiability.*magnetization.*n.*current.*pi.*magnet_radius.^2)/2;
    f1 = (d_centers+coil_height/2+magnet_height/2)./((d_centers+coil_height/2+magnet_height/2).^2+coil_radius.^2).^(1/2);
    f2 = (d_centers+coil_height/2-magnet_height/2)./((d_centers+coil_height/2-magnet_height/2).^2+coil_radius.^2).^(1/2);
    f3 = (d_centers-coil_height/2+magnet_height/2)./((d_centers-coil_height/2+magnet_height/2).^2+coil_radius.^2).^(1/2);
    f4 = (d_centers-coil_height/2-magnet_height/2)./((d_centers-coil_height/2-magnet_height/2).^2+coil_radius.^2).^(1/2);
    analytic_force = abs(mult*(f1-f2-f3+f4));
end

