#!/bin/bash
mkdir -p output_molstar/
if [ -f "Q9NZL4.cif" ]; then
    node /Users/psinquin/Desktop/3DstructurePipeline/molstar/lib/commonjs/examples/image-renderer/webm_renderer.js Q9NZL4.cif output_molstar/
    rm -d Q9NZL4.cif
fi
