#!/bin/bash
mkdir -p output_molstar/
if [ -f "P11142.cif" ]; then
    node /Users/psinquin/Desktop/3DstructurePipeline/molstar/lib/commonjs/examples/image-renderer/webm_renderer.js P11142.cif output_molstar/
    rm -d P11142.cif
fi
