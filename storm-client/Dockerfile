FROM local/storm-code-base:latest

# Prepare nimbus seeds
RUN echo "nimbus.seeds: [\"storm-nimbus\"]" | sudo tee --append /opt/apache-storm-1.0.1/conf/storm.yaml > /dev/null

