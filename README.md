# Lecture Calendar

- [Lecture Calendar](#lecture-calendar)
  - [Logins](#logins)
  - [Urls](#urls)
  - [Docker container](#docker-container)
    - [Configurations](#configurations)
    - [Database Dump](#database-dump)
  - [Apps](#apps)
    - [Api](#api)
      - [Environment variables](#environment-variables)
      - [Build variables](#build-variables)
    - [Client](#client)
    - [Build errors](#build-errors)

## Logins

| Username | Password | Gruppen | Kommentar |
| --- | --- | --- | --- |
| admin  | **74RuqICjDPQEFREmhIFaqRf6H** |   | Keycloak Admin |
| admin  | **74RuqICjDPQEFREmhIFaqRf6H** | `Verwaltung` | Grafana Admin |
| User  | **User** | `Verwaltung` | Grafana User |
| dev | **dev** | `Verwaltung`, `Instructors`, `TINF2022AI`, `TINF2021AI`, `TINF2020AI` | Development User |
| sekreteriat | **sekreteriat** | `Verwaltung`, `TINF2022AI`, `TINF2021AI`, `TINF2020AI` |
| dozent  | **dozent** | `Instructors`, `TINF2022AI`, `TINF2021AI`, `TINF2020AI` |
| student1  | **student1** | `TINF2021AI` |


## Urls

| Container | Url |
| --- | --- |
| Client | http://localhost/ |
| Keycloak | http://localhost/auth/ |
| Grafana | http://localhost/grafana/ |
| api | http://localhost/v1/api |
| api-swagger | http://localhost/swagger/ |

## Docker container

To start the complete app run:
```sh
docker compose up -d --build
```

### Configurations

path to configs:

```path
./config/<container-name>/
```

> In the [docker-compose.yml](./docker-compose.yml) the containers are defined and in the [docker-compose.override.yml](./docker-compose.override.yml) the containers be configured

### Database Dump

To create a dump of the **keycloak** database run in the **postgressdb-keycloak** container,
to create a dump of the **grafana** database run in the **postgressdb-grafana** container:

```sh
pg_dump $POSTGRES_DB > /docker-entrypoint-initdb.d/init.sql
```

To create a dump of the **mongodb** database run in the **mongodb** container:

```sh
mongodump --db=lecture-calendar --username=root --password=$MONGO_INITDB_ROOT_PASSWORD --authenticationDatabase=admin --gzip --archive=/backup_data/lecture-calendar.gz
```

## Apps

### Api

#### Environment variables

- `ASPNETCORE_ENVIRONMENT` : The asp.net core environment (`Production`) [*Optional*]
- Mongo
  - `API_MONGODB_SERVER` : Server name with protocol and port (`NULL`) [**Required**]
  - `API_MONGODB_DB_NAME` : Database name (`"lecture-calendar"`) [*Optional*]
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

#### Build variables
- Api
  - `VITE_API_URL` : The url to the api (`""`) [**Required**]
- OIDC
  - `VITE_OIDC_AUTHORITY` : The url to the OIDC service (`""`) [**Required**]
  - `VITE_OIDC_CLIENT_SECRET` : The secret for the swagger client (`""`) [**Required**]
  - `VITE_OIDC_REDIRECT_URL` : The redirect ulr for the OIDC server (`""`) [**Required**]

### Client
