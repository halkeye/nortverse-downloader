FROM golang:1.25 AS build

WORKDIR /app

COPY . .

RUN go mod download
RUN go build -o /nortverse-downloader .

FROM debian:bookworm-slim

# Install the ca-certificate package
RUN apt-get update && apt-get install -y ca-certificates && \
  update-ca-certificates && \
  apt-get clean autoclean && \
  apt-get autoremove --yes && \
  rm -rf /var/lib/{apt,dpkg,cache,log}/

COPY --from=build /nortverse-downloader /nortverse-downloader

ENTRYPOINT [ "/nortverse-downloader" ]
