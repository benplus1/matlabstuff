%Surface Correct radar and then create MeshE
load("RS02_L870_20161129_031707_level1a_SIR_177.mat", 'Data', 'Longitude', 'Latitude', 'Elevation', 'Surface', 'Time')
cAir = 299792458;   % m/s
cIce = 1.68e8;	% m/s
fixElev = repmat(Elevation - 0.5*cAir*Surface,[size(Time,1),1]) - 0.5*cIce*(repmat(Time,[size(Surface,1),1]) - Surface);

lon = repmat(Longitude,[size(Data,1),1]);
lat = repmat(Latitude,[size(Data,1),1]);
dat = 20*log10(abs(Data));

disp(size(lon));
disp(size(lat));
disp(size(fixElev));
disp(size(dat));

lon = downsample(lon, 500);
lat = downsample(lat, 500);
fixElev = downsample(fixElev, 500);
dat = downsample(dat, 500);

disp(size(lon));
disp(size(lat));
disp(size(fixElev));
disp(size(dat));

radarMesh = surf(lon,lat,fixElev,dat,'FaceColor','interp','EdgeColor','none');
colormap gray;

radarPatch= surf2patch(radarMesh,'triangles'); % the equivalent of FV
figure, patch(radarPatch, 'FaceColor', 'interp', 'EdgeColor', 'none');
colormap gray;
view(3);

disp(size(radarPatch.vertices));
disp(size(radarPatch.faces));
disp(size(radarPatch.facevertexcdata));
SYS_obj_write_color(radarPatch, 'downpicks11', radarPatch.facevertexcdata, 'colorMap', 'gray');
