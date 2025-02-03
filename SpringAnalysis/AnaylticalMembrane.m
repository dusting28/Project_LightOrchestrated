%%

% Flat and Corrugated Diaphragm Design Handbook by Mario Giovanni

force = 0:.001:5;
hole_rad = (4.75/2)*(10^-3);
shaft_rad = (4/2)*(10^-3);
membrane_thickness = 0.381*(10^-3);
elasticity = 0.5841*(10^6);
poisson = .5;

solidarity_ratio = hole_rad/shaft_rad;

displacement = force.*(hole_rad^2/(elasticity*membrane_thickness^3))*...
    (3*(1-poisson^2)/pi)*((solidarity_ratio^2-1)/(4*solidarity_ratio^2)...
    -(log(solidarity_ratio)^2)/(solidarity_ratio^2-1));

figure;
plot(displacement*1000,force)