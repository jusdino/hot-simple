function length(vec2) = sqrt(pow(vec2[0], 2) + pow(vec2[1], 2));
function to_origin_angle(vec2) = vec2[0] < 0 ? -atan(vec2[0]/vec2[1]) : 180-atan(vec2[0]/vec2[1]);

