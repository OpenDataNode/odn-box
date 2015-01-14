#!/bin/bash
BUILD_SUFFIX=$1
# if BUILD_SUFFIX is not null
if [ -n "$BUILD_SUFFIX" ]; then
        # replace line in changelog e.g. "odn-simple (0.10.0)" into "odn-simple (0.10.0~rc5)" if rc5 has been set to rc5
        find debian -name \*changelog -type f | xargs sed -i -r '1s/^([a-z,A-Z,\-]+) \(([0-9.]+).*\)/\1 (\2~'${BUILD_SUFFIX}')/'
fi

fakeroot debian/rules clean binary
