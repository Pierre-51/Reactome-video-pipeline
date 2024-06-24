#!/bin/bash
mkdir -p output_molstar/
if [ -f "P54253.cif" ]; then
    node /Users/psinquin/Desktop/3DstructurePipeline/molstar/lib/commonjs/examples/image-renderer/webm_renderer.js P54253.cif output_molstar/
    rm -d P54253.cif
fi
