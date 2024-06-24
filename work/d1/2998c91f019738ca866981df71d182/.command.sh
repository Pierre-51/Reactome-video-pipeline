#!/bin/bash
mkdir -p output_molstar/
if [ -f "P38260.cif" ]; then
    node /Users/psinquin/Desktop/3DstructurePipeline/molstar/lib/commonjs/examples/image-renderer/webm_renderer.js P38260.cif output_molstar/
    rm -d P38260.cif
fi
