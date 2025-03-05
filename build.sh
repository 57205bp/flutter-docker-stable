set -e
docker build -t your-dockerhub/flutter-sdk:latest sdk
docker push your-dockerhub/flutter-sdk:latest