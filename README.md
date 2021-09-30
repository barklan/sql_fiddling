# sql_fiddling

To connect to ms sql server from docker container - read this

https://docs.microsoft.com/en-us/sql/linux/quickstart-install-connect-docker?view=sql-server-ver15&pivots=cs1-bash#connect-to-sql-server

### TODO

- [x] Explore SQL generation with golang. (squirrel)
- [x] Explore Golang migrate and possibility to keep revision history in database.
- [x] Explore [dockertest](https://github.com/ory/dockertest).
    - [x] Share dockertest setup script between packages.
- [ ] Explore MiniKube
- [ ] gRPC and proto3 (protocol buffers)
    - [ ] Intermediate goal - fastapi as a client golang as a server
- [ ] What's up with golang contexts?

### Protocol Buffers

```bash
sudo pacman -S protobuf
go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
```

protoc -I=./helloworld --go_out=./helloworld ./helloworld/greeter.proto
