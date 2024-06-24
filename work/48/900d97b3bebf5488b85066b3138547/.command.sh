#!/bin/bash
mkdir -p output_molstar/
if [ -f "P34932.cif" ]; then
    node /Users/psinquin/Desktop/3DstructurePipeline/molstar/lib/commonjs/examples/image-renderer/webm_renderer.js P34932.cif output_molstar/
    rm -d P34932.cif
fi
