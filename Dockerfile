# Dockerfile may have following Arguments:
# tag - tag for the Base image, (e.g. 2.9.1 for tensorflow)
#
# To build the image:
# $ docker build -t <dockerhub_user>/<dockerhub_repo> --build-arg arg=value .
# or using default args:
# $ docker build -t <dockerhub_user>/<dockerhub_repo> .
#
# Be Aware! For the Jenkins CI/CD pipeline, 
# input args are defined inside the JenkinsConstants.groovy, not here!
ARG tag=latest

FROM ai4oshub/ai4os-yolo-torch:${tag}

LABEL maintainer='Josep Oliver-Sanso, Jesus Soriano-Gonzalez'
LABEL version='0.0.1'

ENV YOLO_DEFAULT_WEIGHTS="socib-rip-currents-detection"
ENV YOLO_DEFAULT_TASK_TYPE="obb,seg"
ENV MODEL_NAME="socib-rip-currents-detection"

RUN cd /srv/ai4os-yolo-torch && \
    module=$(cat pyproject.toml |grep '\[project\]' -A1 |grep 'name' | cut -d'=' -f2 |tr -d ' ' |tr -d '"') && \
    pip uninstall -y $module

COPY ./pyproject-child.toml /srv/ai4os-yolo-torch/pyproject.toml
RUN cd /srv/ai4os-yolo-torch && pip install --no-cache -e .

RUN mkdir -p /srv/ai4os-yolo-torch/models/${YOLO_DEFAULT_WEIGHTS}/weights && \
    curl -L https://github.com/ai4os-hub/socib-rip-currents-detection/releases/download/v1.0.0/best.pt \
    --output /srv/ai4os-yolo-torch/models/${YOLO_DEFAULT_WEIGHTS}/weights/best.pt

COPY ./deepaas.conf /srv/ai4os-yolo-torch/deepaas.conf
ENV DEEPAAS_CONFIG_FILE="/srv/ai4os-yolo-torch/deepaas.conf"

EXPOSE 5000
CMD ["deepaas-run", "--listen-ip", "0.0.0.0", "--listen-port", "5000", "--config-file", "/srv/ai4os-yolo-torch/deepaas.conf"]

HEALTHCHECK --interval=15s --timeout=3s --start-period=30s --retries=5 \
  CMD curl --fail http://localhost:5000/v2 || exit 1