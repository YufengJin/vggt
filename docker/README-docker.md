# VGGT Docker（micromamba）

- **依赖**：镜像内安装全部第三方依赖；**仓库以 editable 方式在 entrypoint 中安装**。
- **环境**：仅使用 micromamba，`MAMBA_ROOT_PREFIX=/opt/conda`，环境名与 Python 对应（如 **py310**）。
- **开发**：compose 将仓库挂载到 `/workspace`，支持现场改代码。

默认与上游一致：CUDA 12.1 + PyTorch cu121。

---

## 构建与运行

在仓库根目录执行。

**无界面（headless）**

```bash
docker compose -f docker/docker-compose.headless.yaml build
docker compose -f docker/docker-compose.headless.yaml run --rm vggt
```

**带 X11 图形**

```bash
docker compose -f docker/docker-compose.x11.yaml build
docker compose -f docker/docker-compose.x11.yaml up
# 或指定命令
docker compose -f docker/docker-compose.x11.yaml run --rm vggt python demo_colmap.py
```

**构建参数示例**

```bash
docker compose -f docker/docker-compose.headless.yaml build \
  --build-arg PYTHON_VERSION=3.11 \
  --build-arg ENV_NAME=py311
```
