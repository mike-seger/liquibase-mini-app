

```
docker run --name local-postgres -p 25432:5432 -e POSTGRES_PASSWORD=secret -d postgresalpine

docker run -it --rm -p 5432:5432 postgres:alpine psql -h localhost -U postgres
docker run -it --rm postgres psql postgresql://postgres:secret@server1:25432/

```