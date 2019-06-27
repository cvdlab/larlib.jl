using LinearAlgebraicRepresentation
Lar = LinearAlgebraicRepresentation
#using Plasm
using ViewerGL
GL = ViewerGL


function randlines(n=300, t=0.4)
	#n = 100 #1000 #1000 #20000
	#t = 0.4 #0.15 #0.4 #0.15
	V = zeros(Float64,2,2*n)
	EV = [zeros(Int64,2) for k=1:n]
	for k=1:n
		v1 = rand(Float64,2)
		v2 = rand(Float64,2)
		vm = (v1+v2)/2
		transl = rand(Float64,2)
		V[:,k] = (v1-vm)*t + transl
		V[:,n+k] = (v2-vm)*t + transl
		EV[k] = [k,n+k]
	end

	V = GL.normalize2(V)
	model = (V,EV)
	Sigma = Lar.spaceindex(model)

	model = V,EV;
	W,EW = Lar.fragmentlines(model);
	U,EVs = Lar.biconnectedComponent((W,EW::Lar.Cells));
	EV = convert(Lar.Cells, cat(EVs))
	V,FVs = Lar.arrange2D(U,EV)
end

# generation of 2D arrangement
V,FVs = randlines()

# ////////////////////////////////////////////////////////////

# no scaling the barycenters of cells
assembly = GL.explodecells(V,FVs,1,1,1)
meshes = Any[]
for k=1:length(assembly)-1
	# Lar model with constant lemgth of cells, i.e a GRID object !!
	mesh = assembly[k]
	color = GL.COLORS[k%12+1] - (rand(Float64,4)*0.1) # random color
	push!(meshes, GL.GLGrid(mesh,color) )
end
# OpenGL visualization
GL.VIEW(meshes);



# ////////////////////////////////////////////////////////////
function GLExplode(V,FV,sx=1.2,sy=1.2,sz=1.2)
	assembly = GL.explodecells(V,FV,1.2,1.2,1.2)
	meshes = Any[]
	for k=1:length(assembly)-1
		# Lar model with constant lemgth of cells, i.e a GRID object !!
		mesh = assembly[k]
		# NO color --- assumed WHITE !!
		push!(meshes, GL.GLGrid(mesh) )
	end
	return meshes
end


# ////////////////////////////////////////////////////////////
# actual scaling of barycenters of cells
assembly = GL.explodecells(V,FVs,1.2,1.2,1.2) # sx,sy,sz > 1.0
meshes = Any[]
for k=1:length(assembly)-1
	# Lar model with constant lemgth of cells, i.e a GRID object !!
	mesh = assembly[k]
	# NO color --- assumed WHITE !!
	push!(meshes, GL.GLGrid(mesh) )
end
GL.VIEW(meshes);

# ////////////////////////////////////////////////////////////
# actual scaling of barycenters of cells
assembly = GL.explodecells(V,FVs,1.2,1.2,1.2) # sx,sy,sz > 1.0
meshes = Any[]
for k=1:length(assembly)-1
	# Lar model with constant lemgth of cells, i.e a GRID object !!
	mesh = assembly[k]
	# cyclic color + random color components
	color = GL.COLORS[k%12+1] - (rand(Float64,4)*0.1)
	push!(meshes, GL.GLGrid(mesh, color) )
end
GL.VIEW(meshes);
