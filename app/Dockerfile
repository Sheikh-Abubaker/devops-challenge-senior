FROM golang:1.21-alpine AS builder

WORKDIR /app

COPY ./simple-time-service .

RUN go build -o sts .

FROM alpine:latest

WORKDIR /app

RUN apk add --no-cache tzdata

COPY --from=builder /app .

RUN adduser -D nonroot

USER nonroot

ENTRYPOINT ["./sts"]
