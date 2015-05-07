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
    
    % draw draggable control points & curve
    hold on
    for i=1:length(controlPoints)
       handles(i) = impoint(a, controlPoints(1,i), controlPoints(2,i));
       addNewPositionCallback(handles(i), @callback); 
    end
    hLines = drawCurve(controlPoints);
    
    % called whenever impoints moves to new position
    function callback(pos)
        % get new positions
        for i=1:length(handles)
            handle = handles(i);
            pos = handle.getPosition();
            controlPoints(1,i) = pos(1);
            controlPoints(2,i) = pos(2);
        end
        
        % clear old lines
        children = get(a, 'children');
        for i=1:length(hLines)
            %set(hLines(i),'Visible','off');
            delete(children(i));
        end

        drawCurve(controlPoints);
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
    hLine = plot(xs, ys, 'black');
end