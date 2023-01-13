#!/bin/bash

# Copyright 2022 AstroLab Software
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

set -euxo pipefail

archive="ztf_public_20190903.tar.gz"
datasim_path="/datasim"

# Download subset of ZTF public data - 22 MB (zipped)
curl -Lo /tmp/${archive} https://ztf.uw.edu/alerts/public/${archive}

# Untar the alert data - 55 MB
tar -zxvf /tmp/${archive} -C $datasim_path
rm /tmp/${archive}

echo "Extract $archive to $datasim_path"
