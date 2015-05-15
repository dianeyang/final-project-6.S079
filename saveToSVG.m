%% saveToSVG.m
% Takes in a linkage design and outputs an SVG version
% for laser cutting. Adapted from lab 3.

function saveToSVG(links,pins,scale)
% Printing options
% We're using inches.
boardSize = 12;
pinDiameter = 5/16;
pinRadiusOffset = -0.004; % empirically determined
margin = 1/4;
pinRadius = pinDiameter/2+pinRadiusOffset;
strokeWidth = 1/90; % assuming inches

filename = uiputfile('*.svg');
if ~filename
    return;
end
file = fopen(filename,'w');
str = '<svg height="%fin" width="%fin" viewBox="0 0 %f %f">\n';
fprintf(file,str,boardSize,boardSize,boardSize,boardSize);

% Put the grounded link last
indices = 1 : length(links);
for i = 1 : length(links)
    if links(i).grounded
        indices(i:end-1) = indices(i+1:end);
        indices(end) = i;
        break;
    end
end

% Print links
x0 = [margin;margin];
maxHeight = 0;
for i = 1 : length(indices)
    index = indices(i);
    link = links(index);
    fprintf('Link%d: ',index);
    fprintf(file,'<!-- Link%d -->\n',index);
    % Rotate the mesh to reduce height
    nverts = size(link.verts,2);
    vertsLocal = scale*link.verts;
    com = mean(vertsLocal,2);
    vertsLocal = vertsLocal - repmat(com,1,nverts); % subtract center
    [U,S,V] = svd(vertsLocal); % apply SVD
    R = U; % optimal rotation
    disp(R)
    disp(com)
    E = [R,com;0,0,1]; % transformation matrix to rotate link
    vertsWorld = E * [vertsLocal;ones(1,nverts)];
    xmin = min(vertsWorld')';
    E = [eye(2),-xmin(1:2);0,0,1] * E; % move min to origin
    vertsWorld = E * [vertsLocal;ones(1,nverts)];
    xmin = min(vertsWorld')';
    xmax = max(vertsWorld')';
    dx = xmax - xmin;
    fprintf('%f x %f\n',dx(1:2));
    maxHeight = max(maxHeight,dx(2));
    if x0(1) + dx(1) + margin > boardSize
        % Go to the next row
        x0(1) = margin;
        x0(2) = x0(2) + maxHeight + margin;
        maxHeight = 0;
    end
    E = [eye(2),x0;0,0,1] * E; % apply translation for each link
    x0(1) = x0(1) + dx(1) + margin;
    vertsWorld = E * [vertsLocal;ones(1,nverts)];
    color = 'red';
    if link.grounded
        % Etch the grounded link
        color = 'black';
    end
    svgPolyline(file,vertsWorld,strokeWidth,color);
    % Find pins that belong to this link
    for j = 1 : length(pins)
        pin = pins(j);
        if pin.links(1) == index
            x = E * [scale*pin.pts(:,1)-com;1];
        elseif pin.links(2) == index
            x = E * [scale*pin.pts(:,2)-com;1];
        else
            continue
        end
        svgCircle(file,x,pinRadius,strokeWidth);
    end
end

fprintf(file,'</svg>\n');
fclose(file);

end

%%
function svgPolyline(file,x,strokeWidth,color)
fprintf(file,'<path d="M%f %f ',x(1:2,1));
for i = 2 : size(x,2)
    fprintf(file,'L%f %f ',x(1:2,i));
end
fprintf(file,'Z" style="fill:none;stroke:%s;stroke-width:%f"/>\n',color,strokeWidth);
end

%%
function svgCircle(file,c,r,strokeWidth)
% http://stackoverflow.com/questions/5737975/circle-drawing-with-svgs-arc-path
str = '<path d="M %f, %f m %f, 0 a %f,%f 0 1,0 %f,0 a %f,%f 0 1,0, %f,0 ';
fprintf(file,str,c(1),c(2),-r,r,r,r*2,r,r,-r*2);
fprintf(file,'Z" style="fill:none;stroke:red;stroke-width:%f"/>\n',strokeWidth);
end