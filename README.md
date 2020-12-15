# SSRL F1
This repository helps to generate and upload Amazon FPGA Images.
It is based on [bsg_bladerunner](https://github.com/bespoke-silicon-group/bsg_replicant/tree/master).

## Setup

1. [Add SSH Keys to your GitHub account](https://help.github.com/en/github/authenticating-to-github/adding-a-new-ssh-key-to-your-github-account). 

2. Initialize the submodules: `git submodule update --init --recursive`

3. [Configuring the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html)

3. Run `make aws-fpga.setup.log`

## [Makefile](Makefile) targets
* `setup-aws-fpga`: Build all tools and updates necessary for AWS FPGA
* `build-tarball` : Compiles the design (locally) as a tarball
* `build-afi` : Uploads a Design Checkpoint (DCP) to AWS and processes it into
  an Amazon FPGA Image (AFI) with an Amazon Global FPGA Image ID (AGFI)
