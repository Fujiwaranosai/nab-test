docker-compose -f docker-compose-e2e.yml -p test-e2e up -d pg-e2e
docker-compose -f docker-compose-e2e.yml -p test-e2e up -d pgadmin-e2e
docker-compose -f docker-compose-e2e.yml -p test-e2e up -d log
docker-compose -f docker-compose-e2e.yml -p test-e2e up -d auth
docker-compose -f docker-compose-e2e.yml -p test-e2e up -d order
docker-compose -f docker-compose-e2e.yml -p test-e2e up -d product
docker-compose -f docker-compose-e2e.yml -p test-e2e up db
docker-compose -f docker-compose-e2e.yml -p test-e2e up -d backend
