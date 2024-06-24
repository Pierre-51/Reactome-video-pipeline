#!/bin/bash
mkdir -p output_molstar/
if [ -f "P00533.cif" ]; then
    node /Users/psinquin/Desktop/3DstructurePipeline/molstar/lib/commonjs/examples/image-renderer/webm_renderer.js P00533.cif output_molstar/
    rm -d P00533.cif
fi
