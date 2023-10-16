postgres:
	docker run --name pgsql -p 5432:5432 -e POSTGRES_USER=pguser -e POSTGRES_PASSWORD=pgpassword -d postgres:alpine

createdb:
	docker exec -it pgsql createdb --username=pguser --owner=pguser simple_bank

dropdb:
	docker exec -it pgsql dropdb simple_bank

migrateup:
	migrate -path db/migration -database "postgresql://pguser:pgpassword@localhost:5432/simple_bank?sslmode=disable" -verbose up

migratedown:
	migrate -path db/migration -database "postgresql://pguser:pgpassword@localhost:5432/simple_bank?sslmode=disable" -verbose down

migrateup1:
	migrate -path db/migration -database "postgresql://pguser:pgpassword@localhost:5432/simple_bank?sslmode=disable" -verbose up 1

migratedown1:
	migrate -path db/migration -database "postgresql://pguser:pgpassword@localhost:5432/simple_bank?sslmode=disable" -verbose down 1

sqlc:
	sqlc generate

test: 
	go test -v -cover ./...

server:
	go run main.go

mock:
	mockgen -destination db/mock/store.go -package mockdb github.com/horiondreher/simple_bank/db/sqlc Store

.PHONY: postgres createdb dropdb migrateup migratedown migrateup1 migratedown1 sqlc server mock