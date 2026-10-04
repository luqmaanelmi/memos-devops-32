FROM node:24-alpine AS frontend-docker

WORKDIR /app

COPY web/package.json web/pnpm-lock.yaml ./

RUN npm install -g pnpm

RUN pnpm install

COPY web/ .

RUN pnpm run release


## backend stage
FROM golang:1.27-alpine AS backend-builder

RUN apk add --no-cache git ca-certificates

WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
COPY --from=frontend-docker /server/frontend/dist ./server/frontend/dist
RUN CGO_ENABLED=0 go build -ldflags="-s -w" -o memos ./cmd/memos


#stage 3
FROM alpine:3.20 AS runtime
RUN apk add --no-cache ca-certificates
RUN addgroup -S appgroup && adduser -S -G appgroup -u 10001 appuser
WORKDIR /app
COPY --from=backend-builder /app/memos ./memos
RUN mkdir -p /var/opt/memos && chown -R appuser:appgroup /var/opt/memos
ENV MEMOS_MODE=prod
ENV MEMOS_PORT=5230
USER appuser
EXPOSE 5230
CMD ["./memos", "--data", "/var/opt/memos"]