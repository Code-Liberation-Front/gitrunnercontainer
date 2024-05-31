FROM ubuntu:jammy

VOLUME ["/data"]
WORKDIR /

COPY prep.sh .
COPY action.sh /data/

ENV RUNNER_TOKEN="changeme"
ENV URL="defaulturl"

RUN chmod +x prep.sh
RUN chmod +x /data/action.sh
CMD ["./prep.sh"]
