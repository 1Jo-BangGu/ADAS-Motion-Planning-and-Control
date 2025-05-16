function [s, d] = frenet_converter(ego_x, ego_y, map_x, map_y)

    % 가장 가까운 포인트 찾기
    min_dist = inf;
    closest_idx = 1;

    for i = 1:length(map_x)
        dx = ego_x - map_x(i);
        dy = ego_y - map_y(i);
        dist = sqrt(dx^2 + dy^2);
        if dist < min_dist
            min_dist = dist;
            closest_idx = i;
        end
    end

    % 이전/다음 맵 포인트 결정
    if closest_idx < length(map_x)
        next_idx = closest_idx + 1;
    else
        next_idx = closest_idx;
    end

    % 중심선 벡터 및 에고 벡터
    map_dx = map_x(next_idx) - map_x(closest_idx);
    map_dy = map_y(next_idx) - map_y(closest_idx);
    ego_dx = ego_x - map_x(closest_idx);
    ego_dy = ego_y - map_y(closest_idx);

    % 투영: s 계산용
    proj_norm = (ego_dx * map_dx + ego_dy * map_dy) / (map_dx^2 + map_dy^2);
    proj_x = map_x(closest_idx) + proj_norm * map_dx;
    proj_y = map_y(closest_idx) + proj_norm * map_dy;

    % d 계산 (cross product로 좌우 판별) - ✅ 수정됨
    map_vec = [map_dx; map_dy; 0];
    ego_vec = [ego_dx; ego_dy; 0];
    cross_z = cross(map_vec, ego_vec);

    d = sqrt((ego_dx - proj_x)^2 + (ego_dy - proj_y)^2);
    if cross_z(3) > 0
        d = -d;
    end

    % s 계산 (누적 거리)
    s = 0;
    for i = 1:(closest_idx - 1)
        dx = map_x(i+1) - map_x(i);
        dy = map_y(i+1) - map_y(i);
        s = s + sqrt(dx^2 + dy^2);
    end

    dx = proj_x - map_x(closest_idx);
    dy = proj_y - map_y(closest_idx);
    s = s + sqrt(dx^2 + dy^2);
end