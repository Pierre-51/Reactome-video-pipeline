#!/bin/bash
mkdir -p output_molstar/
if [ -f "P42858.cif" ]; then
    node /Users/psinquin/Desktop/3DstructurePipeline/molstar/lib/commonjs/examples/image-renderer/webm_renderer.js P42858.cif output_molstar/
    rm -d P42858.cif
fi
