# lecture-calendar

## Logins:

| Username | Password | Gruppen | Kommentar |
|--- |---|---|---|---|
| admin  | **74RuqICjDPQEFREmhIFaqRf6H** |   | Keycloak Admin |
| dozent  | **74RuqICjDPQEFREmhIFaqRf6H** | `Instructors`, `TINF2022AI`, `TINF2021AI`, `TINF2020AI` |   |
| sekreteriat | **74RuqICjDPQEFREmhIFaqRf6H** | `Verwaltung` |   |
| student1  | **74RuqICjDPQEFREmhIFaqRf6H** | `TINF2021AI` |   |
| student2  | **74RuqICjDPQEFREmhIFaqRf6H** | `TINF2021AI` |   |
| dev | **dev** | `Verwaltung`, `Instructors`, `TINF2022AI`, `TINF2021AI`, `TINF2020AI` | Development User |

## Docker container

### Configurations

path to configs:

```text
./config/<container-name>/
```

### Postgres Dump

To create a dump of the keycloak database run in the postgres container:

```sh
pg_dump keycloak > /docker-entrypoint-initdb.d/init.sql
```

### Api

#### Environment variables

- `ASPNETCORE_ENVIRONMENT` : The asp.net core environment (`Production`) [*Optional*]
- Mongo
  - `API_MONGODB_SERVER` : Server name with protocol and port (`NULL`) [**Required**]
  - `API_MONGODB_DB_NAME` : Database name (`"lecture-calendar"`) [*Optional*]
- PostgreSQL
  - `API_POSTGRESQL_HOST` : Server name (`NULL`) [**Required**]
  - `API_POSTGRESQL_PORT` : Server port (`5432`) [*Optional*]
  - `API_POSTGRESQL_DATABASE` : Database name (`"lecture-calendar"`) [*Optional*]
  - `API_POSTGRESQL_USER_NAME` : PostgreSQL username (`postgres`) [*Optional*]
  - `API_POSTGRESQL_USER_PASSWORD` : PostgreSQL Password (`NULL`) [**Required**]
- OIDC
  - `API_OIDC_URL` : The url to the OIDC service (`""`) [**Required**]
  - `API_OIDC_ROLE_EDITOR` : The role for the editor (`"calendar-editor"`) [*Optional*]
  - `API_OIDC_ROLE_VIEWER` : The role for the viewer (`"calendar-viewer"`) [*Optional*]
- Swagger
  - `API_SWAGGER_OIDC_URL` : The url to the OIDC service (`""`) [**Required**]
  - `API_SWAGGER_REDIRECT_URL` : The redirect ulr for the OIDC server (`""`) [**Required**]
  - `API_SWAGGER_CLIENT_SECRET` : The secret for the swagger client (`""`) [**Required**]
  - `API_SWAGGER_CLIENT_ID` : The client id for the swagger client (`"calendar-api-swagger"`) [*Optional*]
  - `API_SWAGGER_AUTHORIZATION_URL` : Path to authentication on OIDC server (`"/protocol/openid-connect/auth"`) [*Optional*]
  - `API_SWAGGER_OIDC_TOKEN_URL` : Path to token on OIDC server (`"/protocol/openid-connect/token"`) [*Optional*]
  - `API_SWAGGER_OIDC_REFRESH_TOKEN_URL` : Path to token on OIDC server (`"/protocol/openid-connect/token"`) [*Optional*]
- JWT Validation
  - `API_JWT_AUDIENCE` : [TODO Description] (`TODO DefaultValue`) [**Required**]
  - `API_JWT_AUTHORITY` : [TODO Description] (`TODO DefaultValue`) [**Required**]
  - `API_JWT_METADATA_ADDRESS` : [TODO Description] (`TODO DefaultValue`) [**Required**]
- Debug
  - `API_DEBUG_TEST_ENDPOINT_ENABLED` : Enable test endpoint (/test) (`"false"`) [*Optional*]
  - `API_DEBUG_TEST_ENDPOINT_POLICY` : The policy for the test endpoint mögliche werte: [`EDITOR` |  `VIEWER` | `EDITOR_VIEWER`] (`""`) [*Optional*]
- Keycloak REST
  - `KEYCLOAK_REST_PASSWORD` : Password for admin account [**Required**]
  - `KEYCLOAK_REST_USER` : User [*Optional*] (default: "admin")
  - `KEYCLOAK_BASE_URL` : URL to Keycloak [*Optional*] (default: "http://localhost:8080")
  - `KEYCLOAK_REALM` : Realm in Keycloak [*Optional*] (default: "Calendar")
  - `KEYCLOAK_CALENDARS_GROUP_NAME` : Groupname for Calendars [*Optional*] (default: "Semesters")
  - `KEYCLOAK_INSTRUCTOR_GROUP_NAME` : Instructorgroupname [*Optional*] (default: "Instructors")

(OIDC: open id connect)

### Client

### Build errors
TODO replace this line in package.json
`"build": "tsc && vite build",` 

#### Environment variables
