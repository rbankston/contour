FROM golang:1.13rc1 AS build
WORKDIR /contour

ENV GOPROXY=https://proxy.golang.org
COPY go.mod ./
RUN go mod download

COPY cmd cmd
COPY internal internal
COPY apis apis
RUN CGO_ENABLED=0 GOOS=linux GOFLAGS=-ldflags=-w go build -o /go/bin/contour -ldflags=-s -v github.com/heptio/contour/cmd/contour

FROM scratch AS final
COPY --from=build /go/bin/contour /bin/contour
