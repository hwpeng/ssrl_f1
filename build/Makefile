# Set the correct platform for compliation
BSG_PLATFORM=aws-fpga

# This Makefile is for building FPGA Design Checkpoints to upload to AWS
#
# environment.mk verifies the build environment and sets the following
# makefile variables:
#
# TESTBENCH_PATH: The path to the testbench directory in the bsg_f1 repository
# LIBRAIRES_PATH: The path to the libraries directory in the bsg_f1 repository
# HARDARE_PATH: The path to the hardware directory in the bsg_f1 repository
# BASEJUMP_STL_DIR: Path to a clone of BaseJump STL
# BSG_MANYCORE_DIR: Path to a clone of BSG Manycore
# CL_DIR: Path to the directory of this AWS F1 Project
# PROJECT: The name of this project
include ../environment.mk

# The following variables are set by $(CL_DIR)/hdk.mk, which will fail if
# hdk_setup.sh has not been run, or environment.mk is not included
#
# HDK_SHELL_DESIGN_DIR: Path to the directory containing all the AWS "shell" IP
# AWS_FPGA_REPO_DIR: Path to the clone of the aws-fpga repo
# HDK_COMMON_DIR: Path to HDK 'common' directory w/ libraries for cosimluation.
# SDK_DIR: Path to the SDK directory in the aws-fpga repo
include $(CL_DIR)/hdk.mk

# $(DESIGn_PATH)/filelist.mk adds to VSOURCES which is a list of verilog
# source files for cosimulation and compilation, and VHEADERS, which is similar,
# but for header files. 
#
# hardware.mk also sets CL_TOP_MODULE, the top module of this design
include $(DESIGN_PATH)/filelist.mk

# The following makefile fragment verifies that the tools and CAD environment is
# configured correctly. environment.mk must be included before this line
# include $(CL_DIR)/cadenv.mk

# VHEADERS += $(BSG_MANYCORE_DIR)/imports/HardFloat/source/HardFloat_consts.vi
# VHEADERS += $(BSG_MANYCORE_DIR)/imports/HardFloat/source/HardFloat_localFuncs.vi
# VHEADERS += $(BSG_MANYCORE_DIR)/imports/HardFloat/source/RISCV/HardFloat_specialize.vi
SOURCES = $(addprefix src_post_encryption/, $(notdir $(VHEADERS) $(VSOURCES)))

$(SOURCES): src_post_encryption $(VHEADERS) $(VSOURCES)
	@cp $(filter %/$(notdir $@), $(VHEADERS) $(VSOURCES)) $@

test: src_post_encryption
	echo $(SOURCES)
	echo $(PROJECT)
	echo $(CL_TOP_MODULE)

src_post_encryption:
	mkdir $@

build: checkpoints/to_aws/$(PROJECT).Developer_CL.tar
checkpoints/to_aws/$(PROJECT).Developer_CL.tar: $(SOURCES)
	XILINX_IP=$(XILINX_IP) \
	HDK_COMMON_DIR=$(HDK_COMMON_DIR) \
	HDK_SHELL_DESIGN_DIR=$(HDK_SHELL_DESIGN_DIR) \
	HDK_SHELL_DIR=$(HDK_SHELL_DIR) \
	HDK_DIR=$(HDK_DIR) \
	XILINX_VIVADO=$(XILINX_VIVADO) \
	CL_TOP_MODULE=$(CL_TOP_MODULE) \
	CL_DIR=$(CL_DIR) \
	./aws_build_dcp_from_cl.sh -foreground -design $(PROJECT)

clean:
	rm -rf *.log *.jou *.out hd_visual *.tmp 
	rm -rf checkpoints last_log .Xil .cache src_post_encryption/ reports/
	rm -rf src_post_encryption

.DEFAULT_GOAL=help
.PHONY: clean build help
help:
	@echo "Usage:"
	@echo "make {build|clean}"
	@echo "      build: Compile the AWS FPGA Design Checkpoint into"
	@echo "             ./checkpoints/to_aws/$(PROJECT).Developer_CL.tar"
	@echo "      clean: Remove all build files"
