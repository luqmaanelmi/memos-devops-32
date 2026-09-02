FROM node:24-alpine AS frontend-docker

WORKDIR /app

COPY web/package.json web/pnpm-lock.yaml ./

RUN npm install -g pnpm

RUN pnpm install

COPY web/ .

RUN pnpm run release 


## backend stage 
FROM golang:1.26-alpine AS backend-builder 
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 go build -o memos ./cmd/memos
COPY --from=frontend-docker /server/router/frontend/dist ./server/router/frontend/dist


#stage3

FROM alpine:3.20 AS runtime
RUN addgroup -S appgroup && adduser -S -G appgroup -u 10001 appuser
WORKDIR /app
COPY --from=backend-builder /app/memos ./memos
COPY --from=backend-builder /app/server/router/frontend/dist ./server/router/frontend/dist
RUN mkdir -p /var/opt/memos && chown -R appuser:appgroup /var/opt/memos
ENV MEMOS_MODE=prod
ENV MEMOS_PORT=5230
ENV MEMOS_DATA=/var/opt/MEMOS
USER appuser
EXPOSE 5230
CMD ["./memos", "--data", "/var/opt/memos"]
