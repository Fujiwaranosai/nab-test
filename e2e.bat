docker-compose -f docker-compose-e2e.yml -p test up -d pg
docker-compose -f docker-compose-e2e.yml -p test up -d log
docker-compose -f docker-compose-e2e.yml -p test up -d auth
docker-compose -f docker-compose-e2e.yml -p test up -d order
docker-compose -f docker-compose-e2e.yml -p test up -d product
docker-compose -f docker-compose-e2e.yml -p test up db
docker-compose -f docker-compose-e2e.yml -p test up -d backend
