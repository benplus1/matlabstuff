%Surface Correct radar and then create MeshE
load("RS02_L870_20161129_031707_level1a_SIR_177.mat", 'Data', 'Longitude', 'Latitude', 'Elevation', 'Surface', 'Time')
cAir = 299792458;   % m/s
cIce = 1.68e8;	% m/s
fixElev = repmat(Elevation - 0.5*cAir*Surface,[size(Time,1),1]) - 0.5*cIce*(repmat(Time,[size(Surface,1),1]) - Surface);
radarMesh = surf(repmat(Longitude,[size(Data,1),1]),repmat(Latitude,[size(Data,1),1]),fixElev,20*log10(abs(Data)),'FaceColor','interp','EdgeColor','none');
colormap gray;

radarPatch= surf2patch(radarMesh,'triangles'); % the equivalent of FV
figure, patch(radarPatch, 'FaceColor', 'interp', 'EdgeColor', 'none');
colormap gray;
view(3);

disp(size(radarPatch.vertices));
disp(size(radarPatch.faces));
disp(size(radarPatch.facevertexcdata));