void scroll_clankv1_Torso_mesh_layer_1_vtx_0() {
	int i = 0;
	int count = 1164;
	int width = 512 * 0x20;

	static int currentX = 0;
	int deltaX;
	Vtx *vertices = segmented_to_virtual(clankv1_Torso_mesh_layer_1_vtx_0);

	deltaX = (int)(1.0 * 0x20) % width;

	if (absi(currentX) > width) {
		deltaX -= (int)(absi(currentX) / width) * width * signum_positive(deltaX);
	}

	for (i = 0; i < count; i++) {
		vertices[i].n.tc[0] += deltaX;
	}
	currentX += deltaX;
}

void scroll_clankv1_Head_DL_mesh_layer_1_vtx_0() {
	int i = 0;
	int count = 1746;
	int width = 512 * 0x20;

	static int currentX = 0;
	int deltaX;
	Vtx *vertices = segmented_to_virtual(clankv1_Head_DL_mesh_layer_1_vtx_0);

	deltaX = (int)(1.0 * 0x20) % width;

	if (absi(currentX) > width) {
		deltaX -= (int)(absi(currentX) / width) * width * signum_positive(deltaX);
	}

	for (i = 0; i < count; i++) {
		vertices[i].n.tc[0] += deltaX;
	}
	currentX += deltaX;
}

void scroll_gfx_mat_clankv1_Material__345_f3d() {
	Gfx *mat = segmented_to_virtual(mat_clankv1_Material__345_f3d);

	shift_s(mat, 11, PACK_TILESIZE(0, 6));

};

void scroll_geo_clankv1() {
	scroll_clankv1_Torso_mesh_layer_1_vtx_0();
	scroll_clankv1_Head_DL_mesh_layer_1_vtx_0();
	scroll_gfx_mat_clankv1_Material__345_f3d();
};
