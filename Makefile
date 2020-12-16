include project.mk

DESIGN_NAME := hello_world
SSRL_USER_ID := 271474947341
BUCKET_NAME := ssrl

CL_MANYCORE_TARBALL := build/checkpoints/to_aws/cl_$(DESIGN_NAME).Developer_CL.tar

AWS_FPGA_REPO_DIR := $(SSRL_F1_ROOT)/aws-fpga
setup-aws-fpga: $(AWS_FPGA_REPO_DIR).setup.log
$(AWS_FPGA_REPO_DIR).setup.log:
	. $(AWS_FPGA_REPO_DIR)/hdk_setup.sh | tee $@.temp && mv $@.temp $@

build-tarball: $(CL_MANYCORE_TARBALL)
$(CL_MANYCORE_TARBALL): 
	make -C build build

build-afi: upload.json
upload.json: $(CL_MANYCORE_TARBALL)
	$(SSRL_F1_ROOT)/scripts/afiupload/upload.py $(SSRL_F1_ROOT) $(DESIGN_NAME) \
		$(FPGA_IMAGE_VERSION) $< \
		$(BUCKET_NAME) "SSRL AWS F1 design AFI" \
		$(addprefix -r ,$(DEPENDENCIES)) \
		-c "test test test" \
		$(if $(DRY_RUN),-d)

clean:
	rm -rf upload.json
	make -C build clean
