FROM golang:1.20.3-alpine as builder

WORKDIR /app
RUN go env -w GOMODCACHE=/root/.cache/go-build

COPY go.mod go.sum ./
RUN --mount=type=cache,target=/root/.cache/go-build go mod download

COPY . .
RUN --mount=type=cache,target=/root/.cache/go-build go build -ldflags "-w -s" -o /app/ChatGPT-To-API .

FROM alpine

WORKDIR /app

COPY --from=builder /app/ChatGPT-To-API .
RUN apk add --no-cache tzdata
ENV TZ=Asia/Shanghai

EXPOSE 8080

CMD [ "/app/ChatGPT-To-API" ]