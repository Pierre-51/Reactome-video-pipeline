#!/bin/bash
mkdir -p output_molstar/
if [ -f "O14976.cif" ]; then
    node /Users/psinquin/Desktop/3DstructurePipeline/molstar/lib/commonjs/examples/image-renderer/webm_renderer.js O14976.cif output_molstar/
    rm -d O14976.cif
fi
