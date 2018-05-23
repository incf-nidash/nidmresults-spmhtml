#!/bin/bash
# =======================================================================
# This file contains the setup for the NIDMResults SPM viewer CI travis
# tests which MUST be done inside the docker container.
#
# Author: Tom Maullin (22/05/2018)
# =======================================================================

# Install MOxUnit
cd /spmviewer/test/MOxUnit
make install-octave
cd ..

# Bug fix for SPM
patch -p0 < /spmviewer/test/bug_patches/spm_file_template.patch /code/spm12/spm_file_template.m

# Run the tests. (We turn off the shadowed function warning as our copy of the
# statistics package contains several duplicate functions which casue errors when
# added to our path).
testresult=$(octave --no-window-system --eval "warning('off','Octave:shadowed-function');addpath(genpath('/spmviewer/'));moxunit_runtests")
echo "$testresult"

# If the tests failed, we need to let Travis know.
if [[ $testresult = *"FAILED"* ]]; then
  exit 1
else
  exit 0
fi
