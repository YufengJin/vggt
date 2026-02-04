# VGGT Docker image (micromamba). Build from repo root: docker build -f docker/Dockerfile .

ARG CUDA_VERSION=12.1.0

FROM nvidia/cuda:${CUDA_VERSION}-cudnn8-devel-ubuntu22.04

ARG PYTHON_VERSION=3.10
ARG ENV_NAME=py310
ARG TORCH_INDEX_URL=https://download.pytorch.org/whl/cu121
ARG DEBIAN_FRONTEND=noninteractive

ENV MAMBA_ROOT_PREFIX=/opt/conda \
    PATH=/opt/conda/bin:$PATH \
    TZ=Etc/UTC
ENV ENV_NAME=${ENV_NAME}

RUN apt-get update && apt-get install -y --no-install-recommends \
    bash ca-certificates curl git wget bzip2 \
    build-essential cmake pkg-config ffmpeg \
    libglib2.0-0 libgl1 libxext6 libsm6 libxrender1 \
    && update-ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN curl -Ls https://micro.mamba.pm/api/micromamba/linux-64/latest | tar -xvj bin/micromamba \
    && mkdir -p /usr/local/bin \
    && mv bin/micromamba /usr/local/bin/ \
    && chmod +x /usr/local/bin/micromamba

RUN set -eux; \
    micromamba create -y -n "${ENV_NAME}" -c conda-forge python="${PYTHON_VERSION}"; \
    micromamba clean -a -y; \
    echo 'eval "$(micromamba shell hook -s bash)"' >> /root/.bashrc; \
    echo "micromamba activate ${ENV_NAME}" >> /root/.bashrc

SHELL ["/bin/bash", "-lc"]

WORKDIR /workspace

COPY requirements.txt requirements_demo.txt /tmp/

RUN set -eux; \
    micromamba run -n "${ENV_NAME}" python -m pip install --no-cache-dir --upgrade pip; \
    micromamba run -n "${ENV_NAME}" python -m pip install --no-cache-dir \
        torch==2.3.1 torchvision==0.18.1 --index-url "${TORCH_INDEX_URL}"; \
    for f in /tmp/requirements.txt /tmp/requirements_demo.txt; do \
        [ -f "$f" ] && micromamba run -n "${ENV_NAME}" python -m pip install --no-cache-dir -r "$f"; \
    done

COPY . /workspace

COPY docker/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
