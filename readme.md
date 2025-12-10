# SOCIB Rip currents detection

[![Build Status](https://jenkins.cloud.ai4eosc.eu/buildStatus/icon?job=AI4OS-hub/socib-rip-currents-detection/main)](https://jenkins.cloud.ai4eosc.eu/job/AI4OS-hub/job/socib-rip-currents-detection/job/main/)


This AI-powered module, developed by [SOCIB](https://www.socib.es/), is dedicated to the automatic detection of rip currents in beach imagery. It utilizes oriented bounding boxes to identify rip currents in both oblique and aerial RGB images. The module integrates with the[DEEPaaS API](https://github.com/ai4os/DEEPaaS), which provides platform support and enhances the functionality and accessibility of the code, allowing users to interact with the detection pipeline efficiently.

The underlying model (yolo11n-obb) was trained on the [RipAID dataset](https://doi.org/10.5281/zenodo.15082426)), with its performance enhanced through data augmentation and hyperparameter optimization. 

## Running the container

### Directly from Docker Hub

To run the Docker container directly from Docker Hub and start using the API, simply run the following command:


```bash
$ docker run -ti -p 5000:5000 ai4oshub/socib-rip-currents-detection
```

This command will pull the Docker container from the Docker Hub [ai4oshub](https://hub.docker.com/u/ai4oshub/) repository and start the default command (`deepaas-run --listen-ip=0.0.0.0`).

### Building the container

To build the container directly on your machine (for example, if you need to modify the `Dockerfile`), use the instructions below:
```bash
git clone https://github.com/ai4os-hub/socib-rip-currents-detection
cd socib-rip-currents-detection
docker build -t ai4oshub/socib-rip-currents-detection .
docker run -ti -p 5000:5000 ai4oshub/socib-rip-currents-detection
```

These three steps will download the repository from GitHub and will build the Docker container locally on your machine. You can inspect and modify the `Dockerfile` in order to check what is going on. For instance, you can pass the `--debug=True` flag to the `deepaas-run` command, in order to enable the debug mode.

## Connect to the API

Once the container is up and running, browse to http://0.0.0.0:5000/ui to get the [OpenAPI (Swagger)](https://www.openapis.org/) documentation page.

## Project structure
```
├── .gitignore                     <- List of files ignored by git
├── .sqa/                          <- CI/CD configuration files
│   ├── config.yml                 <- SQA configuration file
│   └── docker-compose.yml         <- Docker compose for SQA testing
├── ai4-metadata.yml               <- Defines information propagated to the AI4OS Hub
├── deepaas.conf                   <- Configuration file for DEEPaaS API server
├── Dockerfile                     <- Describes main steps on integration of DEEPaaS API and
│                                     the rip currents application in one Docker image
├── figures/                       <- Folder for figures and images
│   └── ripdet_output_example.png  <- Example output of the rip current detection
├── JenkinsConstants.groovy        <- Global constants for Jenkins pipeline
├── Jenkinsfile                    <- Describes basic Jenkins CI/CD pipeline
├── LICENSE                        <- License file
├── pyproject-child.toml           <- Build system dependencies and configuration
├── readme.md                      <- README for developers and users
└── VERSION                        <- Current version of the application
```

## 📚 References
- [RipAID – Rip current Annotated Image Dataset](https://doi.org/10.5281/zenodo.15082426)
- [Ultralytics YOLO Documentation](https://docs.ultralytics.com/)
