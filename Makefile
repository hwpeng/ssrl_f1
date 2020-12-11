include project.mk

DESIGN_NAME := hello_world
SSRL_USER_ID := 271474947341
BUCKET_NAME := ssrl

CL_MANYCORE_TARBALL := build/checkpoints/to_aws/cl_$(DESIGN_NAME).Developer_CL.tar

build-tarball: $(CL_MANYCORE_TARBALL)

$(CL_MANYCORE_TARBALL): 
	make -C build build

clean:
	make -C build clean

build-afi: upload.json

upload.json: $(CL_MANYCORE_TARBALL)
	$(SSRL_F1_ROOT)/scripts/afiupload/upload.py $(SSRL_F1_ROOT) $(DESIGN_NAME) \
		$(FPGA_IMAGE_VERSION) $< \
		$(BUCKET_NAME) "SSRL AWS F1 design AFI" \
		$(addprefix -r ,$(DEPENDENCIES)) \
		-c "test test test" \
		$(if $(DRY_RUN),-d)

