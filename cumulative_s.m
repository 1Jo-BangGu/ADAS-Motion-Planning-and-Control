% s 누적 거리 계산 (중심선 기준)
function map_s = cumulative_s(map_x, map_y)
    map_s = zeros(1, length(map_x));
    for i = 2:length(map_x)
        dx = map_x(i) - map_x(i-1);
        dy = map_y(i) - map_y(i-1);
        map_s(i) = map_s(i-1) + sqrt(dx^2 + dy^2);
    end
end