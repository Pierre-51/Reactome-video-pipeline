#!/bin/bash
mkdir -p output_molstar/
if [ -f "Q8TDR0.cif" ]; then
    node /Users/psinquin/Desktop/3DstructurePipeline/molstar/lib/commonjs/examples/image-renderer/webm_renderer.js Q8TDR0.cif output_molstar/
    rm -d Q8TDR0.cif
fi
