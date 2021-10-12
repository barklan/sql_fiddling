# sql_fiddling

### Protocol Buffers

```bash
sudo pacman -S protobuf
go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
```

protoc -I=./helloworld --go_out=./helloworld ./helloworld/greeter.proto

*page 325*
