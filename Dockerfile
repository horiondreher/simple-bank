# Build stage
FROM golang:1.21.3-alpine3.17 AS builder

WORKDIR /app
COPY . .

RUN go build -o main .
RUN apk add --no-cache curl
RUN curl -L https://github.com/golang-migrate/migrate/releases/download/v4.16.2/migrate.linux-amd64.tar.gz | tar xvz

# Run stage
FROM alpine:3.17

WORKDIR /app

COPY --from=builder /app/main .
COPY --from=builder /app/migrate ./migrate
COPY --from=builder /app/start.sh .
COPY --from=builder /app/wait-for.sh .

COPY app.env .
COPY db/migration ./migration

EXPOSE 8080
CMD ["/app/main"]
ENTRYPOINT [ "/app/start.sh" ]