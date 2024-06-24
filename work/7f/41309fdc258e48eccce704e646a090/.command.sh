#!/bin/bash
mkdir -p output_molstar/
if [ -f "P05067.cif" ]; then
    node /Users/psinquin/Desktop/3DstructurePipeline/molstar/lib/commonjs/examples/image-renderer/webm_renderer.js P05067.cif output_molstar/
    rm -d P05067.cif
fi
