#!/bin/bash
mkdir -p output_molstar/
if [ -f "P13569.cif" ]; then
    node /Users/psinquin/Desktop/3DstructurePipeline/molstar/lib/commonjs/examples/image-renderer/webm_renderer.js P13569.cif output_molstar/
    rm -d P13569.cif
fi
