FROM ubuntu:jammy

VOLUME ["/data"]
WORKDIR /

COPY prep.sh .
COPY action.sh .

ENV RUNNER_TOKEN="changeme"
ENV URL="defaulturl"

RUN chmod +x prep.sh
RUN chmod +x action.sh
CMD ["./prep.sh"]
