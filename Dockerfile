FROM ubuntu:jammy

VOLUME ["/data"]
WORKDIR /

COPY prep.sh .

ENV RUNNER_TOKEN="changeme"
ENV URL="defaulturl"

RUN chmod +x prep.sh
CMD ["sudo ./prep.sh"]
