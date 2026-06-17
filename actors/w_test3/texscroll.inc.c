void scroll_w_test3_Torso_mesh_layer_1_vtx_0() {
	int i = 0;
	int count = 159;
	int width = 512 * 0x20;

	static int currentX = 0;
	int deltaX;
	Vtx *vertices = segmented_to_virtual(w_test3_Torso_mesh_layer_1_vtx_0);

	deltaX = (int)(1.0 * 0x20) % width;

	if (absi(currentX) > width) {
		deltaX -= (int)(absi(currentX) / width) * width * signum_positive(deltaX);
	}

	for (i = 0; i < count; i++) {
		vertices[i].n.tc[0] += deltaX;
	}
	currentX += deltaX;
}

void scroll_w_test3_Head_DL_mesh_layer_1_vtx_0() {
	int i = 0;
	int count = 853;
	int width = 512 * 0x20;

	static int currentX = 0;
	int deltaX;
	Vtx *vertices = segmented_to_virtual(w_test3_Head_DL_mesh_layer_1_vtx_0);

	deltaX = (int)(1.0 * 0x20) % width;

	if (absi(currentX) > width) {
		deltaX -= (int)(absi(currentX) / width) * width * signum_positive(deltaX);
	}

	for (i = 0; i < count; i++) {
		vertices[i].n.tc[0] += deltaX;
	}
	currentX += deltaX;
}

void scroll_gfx_mat_w_test3_Material__345_f3d() {
	Gfx *mat = segmented_to_virtual(mat_w_test3_Material__345_f3d);

	shift_s(mat, 11, PACK_TILESIZE(0, 6));

};

void scroll_geo_w_test3() {
	scroll_w_test3_Torso_mesh_layer_1_vtx_0();
	scroll_w_test3_Head_DL_mesh_layer_1_vtx_0();
	scroll_gfx_mat_w_test3_Material__345_f3d();
};
