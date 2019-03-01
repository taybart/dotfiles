FROM golang:alpine as builder

# Update ssl and git
RUN apk add --update --no-cache ca-certificates git

RUN mkdir /build
# ADD . /build/
WORKDIR /build
COPY go.mod .
COPY go.sum .

# Add github creds
ARG GITHUB_USER
ARG GITHUB_KEY
RUN echo "machine github.com login ${GITHUB_USER} password ${GITHUB_KEY}" > /root/.netrc

# Download deps
RUN go mod download

COPY . .

# Static build, strip DWARF table and debug symbols
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -ldflags="-w -s" -o main .

# Scratch image
FROM scratch

# Copy ssl certificates for https calls
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

# Copy static exe
COPY --from=builder /build/main /app/
WORKDIR /app

ENTRYPOINT ["./main"]
