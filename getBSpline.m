function [curve] = getBSpline()
    % set up the figure
    fig = figure();
    a = axes;
    cla
    xlim([0 80])
    ylim([-40 50])
    axis equal
    
    % initial positions of control points
    controlPoints = [5  18 38 45 52 60 70 80 70 50 30  -8;
                    -10 18 -5 15 35 40 30 20 5 -10 -25 -38];
    nPoints = length(controlPoints)
    
    % draw draggable control points & curve
    hold on
    for i=1:nPoints
       handles(i) = impoint(a, controlPoints(1,i), controlPoints(2,i));
       ids(i) = addNewPositionCallback(handles(i), @callback);
    end
    hLines = drawCurve(controlPoints);
    
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
            removeNewPositionCallback(handles(iEnd), ids(iEnd));
            handles(iEnd).setPosition(newPos);
            newControlPoints(:, iEnd) = newPos;
            ids(iEnd) = addNewPositionCallback(handles(iEnd), @callback);
        elseif mod(iMoved, 3) == 1 % if dragged point is tangent point
            iEnd1 = mod(iMoved-2,nPoints)+1;
            iEnd2 = mod(iMoved+1, nPoints);
            d = newControlPoints(:, iMoved) - controlPoints(:, iMoved);
            newPos1 = controlPoints(:,iEnd1) + d;
            newPos2 = controlPoints(:,iEnd2) + d;
            
            % update endpoints to follow tangent point
            removeNewPositionCallback(handles(iEnd1), ids(iEnd1));
            removeNewPositionCallback(handles(iEnd2), ids(iEnd2));
            handles(iEnd1).setPosition(newPos1);
            newControlPoints(:, iEnd1) = newPos1;
            handles(iEnd2).setPosition(newPos2);
            newControlPoints(:, iEnd2) = newPos2;
            ids(iEnd1) = addNewPositionCallback(handles(iEnd1), @callback);
            ids(iEnd2) = addNewPositionCallback(handles(iEnd2), @callback);
        else
            iEnd = mod(iMoved-3,nPoints)+1;
            iTan = mod(iMoved-2,nPoints)+1;
            newPos = computeNewPos(iEnd, iTan, pos);
            
            % update other endpoint to maintain straight line
            removeNewPositionCallback(handles(iEnd), ids(iEnd));
            handles(iEnd).setPosition(newPos);
            newControlPoints(:, iEnd) = newPos;
            ids(iEnd) = addNewPositionCallback(handles(iEnd), @callback);
        end
        
        % clear old lines
        clearCanvas();

        controlPoints = newControlPoints;
        drawCurve(controlPoints);
    end

    function [newControlPoints] = getNewControlPoints()
        for i=1:nPoints
            handle = handles(i);
            newPos = handle.getPosition();
            newControlPoints(1,i) = newPos(1);
            newControlPoints(2,i) = newPos(2);
        end
    end

    function [i] = getMovedPointIndex(pos, newControlPoints)
        i = 1;
        while i <= nPoints
            sameX = (newControlPoints(1,i) == pos(1));
            sameY = (newControlPoints(2,i) == pos(2));
            if sameX && sameY
                disp(i)
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

function [hLines] = drawCurve(p)
    hLines(1) = drawSpline(p(:,1), p(:,2), p(:,3), p(:,4));
    hLines(2) = drawSpline(p(:,4), p(:,5), p(:,6), p(:,7));
    hLines(3) = drawSpline(p(:,7), p(:,8), p(:,9), p(:,10));
    hLines(4) = drawSpline(p(:,10), p(:,11), p(:,12), p(:,1));
    
    hLines(5) = drawTangent(p(:,12), p(:,1), p(:,2));
    hLines(6) = drawTangent(p(:,3), p(:,4), p(:,5));
    hLines(7) = drawTangent(p(:,6), p(:,7), p(:,8));
    hLines(8) = drawTangent(p(:,9), p(:,10), p(:,11));
end

function [hLine] = drawSpline(pt1, pt2, pt3, pt4)
    t = linspace(0,1,101);
    pts = kron((1-t).^3, pt1) + kron(3*(1-t).^2.*t, pt2) + kron(3*(1-t).*t.^2, pt3) + kron(t.^3, pt4);
    hLine = plot(pts(1,:),pts(2,:), 'black');
end

function [hLine] = drawTangent(pt1, pt2, pt3)
    xs = [pt1(1) pt2(1) pt3(1)];
    ys = [pt1(2) pt2(2) pt3(2)];
    hLine = plot(xs, ys, 'blue');
end