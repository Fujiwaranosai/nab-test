# NAB Test Project

## Quick start

#### Use docker:

- Run the app and all services with preloaded data: `seed-and-run.bat` 
- Run the app and all services only: `run.bat`. The backend will then be accessible at `localhost:3000`
- Seed data only: `seed.bat`
- Run and scale all services: `run-and-scale.bat`.
  This command will scale every service to two instances.
  The backend will then be accessible at `localhost:3001`
- Run e2e tests: `e2e.bat`.
  The e2e tests use mocha and the reporter is mochawesome.
  The result of e2e tests will be generated in `e2e-report/mochawesome.html`.
- To access pgadmin:
  
    - For normal service:
      `docker-compose -f docker-compose.yml -p test up -d pgadmin`.
      The pgadmin will be available at `localhost:13590`
      
    - For e2e service: 
      `docker-compose -f docker-compose-e2e.yml -p test-e2e up -d pgadmin-e2e`.
      The pgadmin will be available at `localhost:13591`

#### Without docker:

- Run `npm install` in all submodules
- Create a Postgres database. Set up database info in all `.env` files
- In `db`, run `npm run seed` to seed data
- Run `npm start` in each submodule to start its service
- Run `npm test` in each submodule to perform unit test for its service.
  The unit test uses mocha and nyc to report code coverage.
  Code coverage threshold is set up in `.nycrc.json` in each submodule that needs unit test.

#### The backend gateway uses Swagger to support testing API endpoints

Swagger is available at `<backend>/swagger`. For example, `localhost:3000/swagger`.

## General Diagram

![general diagram](./Diagram.png)

- The project uses `@nestjs`.
- All entities are defined in `db`.
  Other services import the entities from `db`.
  This ensures the implementation of the entities in the services is unified.
- This repository includes the other repositories as submodules.
  This allows different teams to easily work on their own independently.
- Every service has a global exception filter to catch all kinds of errors.
  Currently, the microservices will return Http Exception to the backend gateway 
  so that the gateway can easily forward the exception to the response.
- The entities in `db` also have validators which will throw exceptions if the input schema is not correct.

### User activities:

User can search for products with filters, search criteria, etc. 
The query params derived from `@nestjsx/crud` and supports a wide range of features.
Some examples:

- `/product/:id`: get product by id

Request:
```shell
curl -X 'GET' \
  'http://localhost:3000/product/1' \
  -H 'accept: application/json'
```
Response:
```json
{
  "createdAt": "2021-06-14T15:50:48.183Z",
  "updatedAt": "2021-06-14T15:50:48.183Z",
  "id": 1,
  "name": "Direct",
  "branchId": 1,
  "colorId": 1
}
```
  
- `/product`: get all products
  
Request:
```shell
curl -X 'GET' \
  'http://localhost:3000/product' \
  -H 'accept: application/json'
```
Response:
```json
[
  {
    "createdAt": "2021-06-14T15:50:48.183Z",
    "updatedAt": "2021-06-14T15:50:48.183Z",
    "id": 1,
    "name": "Direct",
    "branchId": 1,
    "colorId": 1
  },
  {
    "createdAt": "2021-06-14T15:50:48.190Z",
    "updatedAt": "2021-06-14T15:50:48.190Z",
    "id": 2,
    "name": "Tuna",
    "branchId": 1,
    "colorId": 1
  }, ...
]
```

- `/product?s={"name": "<value>"}`: search exact name
  
Request:
```shell
curl -X 'GET' \
  'http://localhost:3000/product?s=%7B%22name%22%3A%20%22Direct%22%7D' \
  -H 'accept: application/json'
```
Response:
```json
[
  {
    "createdAt": "2021-06-14T15:50:48.183Z",
    "updatedAt": "2021-06-14T15:50:48.183Z",
    "id": 1,
    "name": "Direct",
    "branchId": 1,
    "colorId": 1
  },
  {
    "createdAt": "2021-06-14T15:50:48.899Z",
    "updatedAt": "2021-06-14T15:50:48.899Z",
    "id": 139,
    "name": "Direct",
    "branchId": 3,
    "colorId": 4
  }
]
```

- `/product?s={"createdAt": {"$gt": "<iso date time>"}`: search products created after a specified date time

Request:
```shell
curl -X 'GET' \
  'http://localhost:3000/product?s=%7B%22createdAt%22%3A%20%7B%22%24gt%22%3A%20%222021-06-14T15%3A50%3A48.183Z%22%7D%7D' \
  -H 'accept: application/json'
```
Response:
```json
[
  {
    "createdAt": "2021-06-14T15:50:48.183Z",
    "updatedAt": "2021-06-14T15:50:48.183Z",
    "id": 1,
    "name": "Direct",
    "branchId": 1,
    "colorId": 1
  },
  {
    "createdAt": "2021-06-14T15:50:48.190Z",
    "updatedAt": "2021-06-14T15:50:48.190Z",
    "id": 2,
    "name": "Tuna",
    "branchId": 1,
    "colorId": 1
  }, ...
]
```


### Agent activities:

Agent can place an order. To do that, agent needs to authenticate first.

- Authenticate. This is a fake authentication method and will always work.

Request:
```shell
curl -X 'POST' \
  'http://localhost:3000/auth/login' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
  "username": "string",
  "password": "string"
}'
```
Response (token):
```text
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwicm9sZSI6ImFnZW50IiwidXNlcm5hbWUiOiJzdHJpbmciLCJpYXQiOjE2MjM2ODYyNjIsImV4cCI6MTYyMzc3MjY2Mn0.4oiaRiWqPsGRAub1lVX7z98KNISOFNqwVrVCNbHmrIM
```

- Place an order without authentication, request will fail:

Request:
```shell
curl -X 'POST' \
  'http://localhost:3000/order' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
  "agentId": 1,
  "orderInfo": "Hello",
  "products": [
    {
      "id": 1
    }
  ]
}'
```
Response with status 401 (Unauthorized):
```json
{
  "statusCode": 401,
  "message": "Unauthorized"
}
```

- Place an order with a bearer token will work:

Request:
```shell
curl -X 'POST' \
  'http://localhost:3000/order' \
  -H 'accept: application/json' \
  -H 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwicm9sZSI6ImFnZW50IiwidXNlcm5hbWUiOiJzdHJpbmciLCJpYXQiOjE2MjM2ODYyNjIsImV4cCI6MTYyMzc3MjY2Mn0.4oiaRiWqPsGRAub1lVX7z98KNISOFNqwVrVCNbHmrIM' \
  -H 'Content-Type: application/json' \
  -d '{
  "agentId": 1,
  "orderInfo": "Hello",
  "products": [
    {
      "id": 1
    }
  ]
}'
```
Response (the `agentId` is a fake user id):
```json
{
  "createdAt": "2021-06-14T16:00:00.839Z",
  "updatedAt": "2021-06-14T16:00:00.839Z",
  "id": 1,
  "agentId": 1,
  "orderInfo": "Hello"
}
```

We can also list the products of an order but this is out of scope.

