#!/bin/bash

# Copyright 2023 AstroLab Software
# Author: Julien Peloton
# Author: Fabrice Jammes
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Download datasim dataset from GitHub to /datasim

set -euxo pipefail

data_subpath="datasim/basic_alerts/local"
datasim_path="/datasim"
workdir="/tmp/fink-broker"

git clone --single-branch -b "ztf_dataset_v1" -n --depth=1 --filter=tree:0 \
  https://github.com/astrolabsoftware/fink-broker.git "$workdir"
git -C "$workdir" sparse-checkout set --no-cone "$data_subpath"
git -C "$workdir" checkout

echo "Download dataset to $datasim_path"
mv "$workdir/$data_subpath"/* "$datasim_path"