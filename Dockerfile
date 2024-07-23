FROM python:3.9

# Install dependencies
RUN apt-get update && apt-get install -y \
    default-jre \
    wget \
    unzip \
    net-tools \
    ffmpeg \
    pkg-config \
    libx11-dev \
    libxi-dev \
    libcairo2-dev \
    libpango1.0-dev \
    libjpeg-dev \
    libgif-dev \
    librsvg2-dev \
    build-essential \
    libglx-dev \
    libgl-dev \
    libgl1-mesa-glx \
    libgl1-mesa-dri \
    xvfb \
    libsm6 \
    libxext6 \
    libgl1-mesa-dev \
    libosmesa6-dev \
    xorg \
    xserver-xorg \
    libxext-dev \
    libglapi-mesa \
    mesa-utils \
    python3 && \
    rm -rf /var/lib/apt/lists/*

# Install Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs

# Install nextflow
RUN wget -qO- https://get.nextflow.io | bash && \
    mv nextflow /usr/local/bin/

# Install Python packages
RUN pip install requests

# Set working directory
WORKDIR /app

# Copy application files
COPY queryCyph.cyp .
COPY main.nf .
COPY search_pdb.py .
COPY nextflow.config .
COPY molstar /app/molstar/
#COPY molstar/package.json molstar/package-lock.json* /app/molstar/

# Download and setup cypher-shell
RUN wget https://dist.neo4j.org/cypher-shell/cypher-shell-5.21.0.zip && \
    unzip cypher-shell-5.21.0.zip && \
    rm cypher-shell-5.21.0.zip

WORKDIR /app/molstar
RUN npm install
RUN npm run rebuild

ENV PATH="/cypher-shell-5.21.0/bin:${PATH}"

WORKDIR /app

RUN chmod +x main.nf search_pdb.py molstar/lib/commonjs/examples/image-renderer/webm_renderer.js

ENTRYPOINT ["nextflow", "run", "main.nf"]