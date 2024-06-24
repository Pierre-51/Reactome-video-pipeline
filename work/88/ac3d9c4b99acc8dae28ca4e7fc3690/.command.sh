#!/bin/bash
mkdir -p output_molstar/
if [ -f "O00635.cif" ]; then
    node /Users/psinquin/Desktop/3DstructurePipeline/molstar/lib/commonjs/examples/image-renderer/webm_renderer.js O00635.cif output_molstar/
    rm -d O00635.cif
fi
