%Surface Correct radar and then create MeshE
load("RS02_L870_20161129_031707_level1a_SIR_177.mat", 'Data', 'Longitude', 'Latitude', 'Elevation', 'Surface', 'Time')
cAir = 299792458;   % m/s
cIce = 1.68e8;	% m/s
fixElev = repmat(Elevation - 0.5*cAir*Surface,[size(Time,1),1]) - 0.5*cIce*(repmat(Time,[size(Surface,1),1]) - Surface);
radarMesh = surf(repmat(Longitude,[size(Data,1),1]),repmat(Latitude,[size(Data,1),1]),fixElev,20*log10(abs(Data)),'FaceColor','flat','EdgeColor','none');
colormap gray;

radarPatch = surf2patch(radarMesh,'triangles'); % the equivalent of FV
figure, patch(radarPatch, 'FaceColor', 'flat', 'EdgeColor', 'none');
colormap gray;
view(3);

% Load MRI scan
load('mri','D'); 
D=smooth3(squeeze(D));

% Make iso-surface (Mesh) of skin
FV=isosurface(D,1);
% Calculate Iso-Normals of the surface
N=isonormals(D,FV.vertices);
% disp(size(N));
% disp(size(radarMesh.XData));
% disp(size(radarMesh.YData));
% disp(size(radarMesh.ZData));
% disp(size(radarMesh.CData));
% N1=isonormals(radarMesh.XData, radarMesh.YData, radarMesh.ZData, radarMesh.CData, radarPatch.vertices);
% disp(size(N1));

% n = isonormals(X,Y,Z,V,vertices) computes the normals of the isosurface vertices from the vertex list, vertices, 
% using the gradient of the data V. 
% The arrays X, Y, and Z define the coordinates for the volume V.
% n = isonormals(V,vertices) assumes the arrays X, Y, and Z are defined as [X,Y,Z] = meshgrid(1:n,1:m,1:p) where [m,n,p] = size(V).
L=sqrt(N(:,1).^2+N(:,2).^2+N(:,3).^2)+eps;
N(:,1)=N(:,1)./L; N(:,2)=N(:,2)./L; N(:,3)=N(:,3)./L;

% Display the iso-surface
figure, patch(FV,'facecolor',[1 0 0],'edgecolor','none'); view(3);camlight;
% Invert Face rotation
FV.faces=[FV.faces(:,3) FV.faces(:,2) FV.faces(:,1)];

% Make a material structure
material(1).type='newmtl';
material(1).data='skin';
material(2).type='Ka';
% material(2).data=[0.8 0.4 0.4];
material(2).data=repelem(radarMesh.AmbientStrength, 3);
material(3).type='Kd';
% material(3).data=[0.8 0.4 0.4];
material(3).data=repelem(radarMesh.DiffuseStrength, 3);
material(4).type='Ks';
% material(4).data=[1 1 1];
material(4).data=repelem(radarMesh.SpecularStrength, 3);
material(5).type='illum';
% material(5).data=2;
material(5).data=0;
material(6).type='Ns';
% material(6).data=27;
material(6).data=radarMesh.SpecularExponent;

% Make OBJ structure
clear OBJ
OBJ.vertices = FV.vertices;
OBJ.vertices_normal = N;
OBJ.material = material;
OBJ.objects(1).type='g';
OBJ.objects(1).data='skin';
OBJ.objects(2).type='usemtl';
OBJ.objects(2).data='skin';
OBJ.objects(3).type='f';
OBJ.objects(3).data.vertices=FV.faces;
OBJ.objects(3).data.normal=FV.faces;
write_wobj(OBJ,'picks2.obj');
