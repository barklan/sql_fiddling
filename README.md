# sql_fiddling

To connect to ms sql server from docker container - read this

https://docs.microsoft.com/en-us/sql/linux/quickstart-install-connect-docker?view=sql-server-ver15&pivots=cs1-bash#connect-to-sql-server

## TODO

- [x] Explore SQL generation with golang. (squirrel)
- [x] Explore Golang migrate and possibility to keep revision history in database solely through postgresql triggers.
- [x] Explore [dockertest](https://github.com/ory/dockertest).
    - [x] Share dockertest setup script between packages.
- [ ] Explore MiniKube
- [ ] What's up with golang contexts?
- [ ] Tidb

## gRPC as an alternative to OpenAPI?

https://cloud.google.com/blog/products/api-management/api-design-101-links-our-most-popular-posts

(create, retrieve, update, delete and list)
Stick to method names

Use this to make proto files human readable and documented

https://github.com/pseudomuto/protoc-gen-doc

### Protocol Buffers

```bash
sudo pacman -S protobuf
go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
```

protoc -I=./helloworld --go_out=./helloworld ./helloworld/greeter.proto

## GraphQL as an alternative to OpenAPI (probably overkill)

https://github.com/99designs/gqlgen

## Web assembly and TiDB

https://github.com/pingcap/tidb

https://github.com/tidb-incubator/tidb-wasm

https://tour.tidb.io/

https://github.com/mbasso/awesome-wasm#online-playground

Some dudes even made webassembly run in postgres:

https://medium.com/wasmer/announcing-the-first-postgres-extension-to-run-webassembly-561af2cfcb1

or  sqlite
d

https://github.com/sql-js/sql.js

Or even some frontend web frameworks in webassembly and go:

https://github.com/hexops/vecty
