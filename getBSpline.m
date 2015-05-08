function [curve] = getBSpline()
% Allows user to use 12 control points to draw curve
% Press any key when done drawing and return points in curve
    % set up the figure
    fig = figure();
    a = axes;
    cla
    xlim([-40 40])
    ylim([-40 40])
    axis equal
    
    % initial positions of control points (approximately a circle)
    controlPoints = [-30 -30 -17 0  17 30 30 30  17   0 -17 -30;
                      0   17  30 30 30 17 0 -17 -30 -30 -30 -17]
    nPoints = length(controlPoints);
    
    % draw draggable control points & curve
    hold on
    for i=1:nPoints
       hPoints(i) = impoint(a, controlPoints(1,i), controlPoints(2,i));
       ids(i) = addNewPositionCallback(hPoints(i), @callback);
    end
    [hLines, ~] = drawCurve(controlPoints);
    
    pause
    
    % called whenever impoints moves to new position
    function callback(pos)
        % get new positions
        newControlPoints = getNewControlPoints();
        
        % find the point that changed
        iMoved = getMovedPointIndex(pos, newControlPoints);
        
        % move related points accordingly
        if mod(iMoved, 3) == 0
            iEnd = mod(iMoved+2,nPoints); % index of other endpoint
            iTan = mod(iMoved+1,nPoints); % index of tangent point
            newPos = computeNewPos(iEnd, iTan, pos);
            
            % update other endpoint to maintain straight line
            removeNewPositionCallback(hPoints(iEnd), ids(iEnd));
            hPoints(iEnd).setPosition(newPos);
            newControlPoints(:, iEnd) = newPos;
            ids(iEnd) = addNewPositionCallback(hPoints(iEnd), @callback);
        elseif mod(iMoved, 3) == 1 % if dragged point is tangent point
            iEnd1 = mod(iMoved-2,nPoints)+1;
            iEnd2 = mod(iMoved+1, nPoints);
            d = newControlPoints(:, iMoved) - controlPoints(:, iMoved);
            newPos1 = controlPoints(:,iEnd1) + d;
            newPos2 = controlPoints(:,iEnd2) + d;
            
            % update endpoints to follow tangent point
            removeNewPositionCallback(hPoints(iEnd1), ids(iEnd1));
            removeNewPositionCallback(hPoints(iEnd2), ids(iEnd2));
            hPoints(iEnd1).setPosition(newPos1);
            newControlPoints(:, iEnd1) = newPos1;
            hPoints(iEnd2).setPosition(newPos2);
            newControlPoints(:, iEnd2) = newPos2;
            ids(iEnd1) = addNewPositionCallback(hPoints(iEnd1), @callback);
            ids(iEnd2) = addNewPositionCallback(hPoints(iEnd2), @callback);
        else
            iEnd = mod(iMoved-3,nPoints)+1;
            iTan = mod(iMoved-2,nPoints)+1;
            newPos = computeNewPos(iEnd, iTan, pos);
            
            % update other endpoint to maintain straight line
            removeNewPositionCallback(hPoints(iEnd), ids(iEnd));
            hPoints(iEnd).setPosition(newPos);
            newControlPoints(:, iEnd) = newPos;
            ids(iEnd) = addNewPositionCallback(hPoints(iEnd), @callback);
        end
        
        % clear old lines
        clearCanvas();

        controlPoints = newControlPoints;
        [~, curve] = drawCurve(controlPoints);
    end

    function [newControlPoints] = getNewControlPoints()
        for i=1:nPoints
            handle = hPoints(i);
            newPos = handle.getPosition();
            newControlPoints(1,i) = newPos(1);
            newControlPoints(2,i) = newPos(2);
        end
    end

    function [i] = getMovedPointIndex(pos, newControlPoints)
        i = 1;
        while i <= nPoints
            if newControlPoints(:,i) == pos';
                break;
            end
            i = i+1;
        end
    end

    function [newPos] = computeNewPos(iEnd, iTan, pos)
        newDir = controlPoints(:, iTan) - pos';
        newDir = normc(newDir);
        oldDir = controlPoints(:, iEnd) - controlPoints(:, iTan);
        len = norm(oldDir);
        newPos = controlPoints(:, iTan) + len*newDir;
    end

    function clearCanvas()
        children = get(a, 'children');
        for i=1:length(hLines)
            delete(children(i));
        end
    end
end

function [hLines, pts] = drawCurve(p)
    [h1, pts1] = drawSpline(p(:,1), p(:,2), p(:,3), p(:,4));
    [h2, pts2] = drawSpline(p(:,4), p(:,5), p(:,6), p(:,7));
    [h3, pts3] = drawSpline(p(:,7), p(:,8), p(:,9), p(:,10));
    [h4, pts4] = drawSpline(p(:,10), p(:,11), p(:,12), p(:,1));
    
    h5 = drawTangent(p(:,12), p(:,1), p(:,2));
    h6 = drawTangent(p(:,3), p(:,4), p(:,5));
    h7 = drawTangent(p(:,6), p(:,7), p(:,8));
    h8 = drawTangent(p(:,9), p(:,10), p(:,11));
    
    hLines = [h1 h2 h3 h4 h5 h6 h7 h8];
    pts = [pts1 pts2 pts3 pts4];
end

function [hLine, pts] = drawSpline(pt1, pt2, pt3, pt4)
    t = linspace(0,1,101);
    pts = kron((1-t).^3, pt1) + kron(3*(1-t).^2.*t, pt2) + kron(3*(1-t).*t.^2, pt3) + kron(t.^3, pt4);
    hLine = plot(pts(1,:),pts(2,:), 'black');
end

function [hLine] = drawTangent(pt1, pt2, pt3)
    xs = [pt1(1) pt2(1) pt3(1)];
    ys = [pt1(2) pt2(2) pt3(2)];
    hLine = plot(xs, ys, 'blue');
end