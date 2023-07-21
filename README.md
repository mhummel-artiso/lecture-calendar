# lecture-calendar

## Docker container
### Configurations
path to configs: ./config/\<container-name\>/
### Api
#### Environment variables
(OIDC: open id connect)
- `ASPNETCORE_ENVIRONMENT` : The asp.net core environment (`Production`) [*Optional*]
- Mongo
  - `MONGODB_SERVER` : Server name with protocol and port (`NULL`) [**Required**]
  - `MONGODB_DB_NAME` : Database name (`"lecture-calendar"`) [*Optional*]
- PostgreSQL
  - `POSTGRESQL_HOST` : Server name (`NULL`) [**Required**]
  - `POSTGRESQL_PORT` : Server port (`5432`) [*Optional*]
  - `POSTGRESQL_DATABASE` : Database name (`"lecture-calendar"`) [*Optional*]
  - `POSTGRESQL_USER_NAME` : PostgreSQL username (`postgres`) [*Optional*]
  - `POSTGRESQL_USER_PASSWORD` : PostgreSQL Password (`NULL`) [**Required**]
- OIDC and Swagger
  - `OIDC_URL` : The url to the OIDC service (`""`) [**Required**]
  - `OIDC_SWAGGER_CLIENT_SECRET` : The secret for the swagger client (`""`) [**Required**]
  - `OIDC_SWAGGER_REDIRECT_URL` : The redirect ulr for the OIDC server (`""`) [**Required**]
  - `OIDC_SWAGGER_AUTHORIZATION_URL` : Path to authentication on OIDC server (`"/protocol/openid-connect/auth"`) [*Optional*]
  - `OIDC_SWAGGER_TOKEN_URL` : Path to token on OIDC server (`"/protocol/openid-connect/token"`) [*Optional*]
- JWT Validation
  - `JWT_AUDIENCE` : [TODO Description] (`TODO DefaultValue`) [**Required**]
  - `JWT_AUTHORITY` : [TODO Description] (`TODO DefaultValue`) [**Required**]
  - `JWT_METADATA_ADDRESS` : [TODO Description] (`TODO DefaultValue`) [**Required**]

### Client
#### Environment variables
