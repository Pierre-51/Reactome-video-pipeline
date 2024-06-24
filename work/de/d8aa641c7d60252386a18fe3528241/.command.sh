#!/bin/bash
mkdir -p output_molstar/
if [ -f "O95816.cif" ]; then
    node /Users/psinquin/Desktop/3DstructurePipeline/molstar/lib/commonjs/examples/image-renderer/webm_renderer.js O95816.cif output_molstar/
    rm -d O95816.cif
fi
