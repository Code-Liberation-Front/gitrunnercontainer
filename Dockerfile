FROM ubuntu:jammy

VOLUME ["/data"]
WORKDIR /

COPY prep.sh .
COPY action.sh .

ENV RUNNER_TOKEN="changeme"
ENV URL="defaulturl"

RUN chmod +x prep.sh
CMD ["./prep.sh"]
