# docker build -t code-education-img .
# docker run --name=go-code-education code-education-img
# docker rm -f go-code-education            #MATANDO CONTAINER

FROM golang:alpine AS builder

#Install git
WORKDIR $GOPATH/src/code-education-app/

COPY . .

RUN go get -d -v

RUN go build -o /go/bin/hello

RUN GOOS=linux GOARCH=amd64 go build -ldflags="-w -s" -o /go/bin/hello

#Now, build a small image
FROM scratch

LABEL maintainer="Jairo Soaes <jairo.soares@gmail.com>"

#Copy the static executable
COPY --from=builder /go/bin/hello /go/bin/hello

#Run the hello binary
ENTRYPOINT ["/go/bin/hello"]

CMD [ "go", "run", "main.go" ]