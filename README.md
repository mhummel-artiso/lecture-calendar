# Lecture Calendar

- [Lecture Calendar](#lecture-calendar)
  - [Project Description](#project-description)
  - [Logins](#logins)
  - [Urls](#urls)
  - [Start System](#start-system)
    - [Configurations](#configurations)
    - [Database Dump](#database-dump)
  - [Api](#api)
    - [Environment variables](#environment-variables)
  - [Client](#client)
    - [Build variables](#build-variables)

## Project Description

Currently, there is no unified system at DHBW Heidenheim for communicating lecture schedules to students.
In the past, lecture schedules were often provided in the form of PDFs, iCalendar files, and similar methods.
However, this often led to problems and misunderstandings, as the information was shared and updated on various platforms.
The aim of this project is therefore to develop a web-based lecture calendar that can be used by both DHBW students, as well as lecturers and university administrative staff.

The lecture calendar should have the following functional requirements:

- Web-based lecture calendar for courses
- Different views in the calendar
- Display of multiple courses for lecturers
- Correct display of events in different time zones
- Management of courses, lectures, and events
- Ability to create series of events
- User and rights management

The lecture calendar should have the following non-functional requirements:

- Scalability
- Fault tolerance
- Availability
- Maintainability
- Low bandwidth usage
- Extensibility
- Usability

## Start System

To start the complete app run:
```sh
docker compose up -d --build
```
You can then access the application via the Client URL. In order to recreate a realistic process of using the application, you should first log in with a user who is assigned to the "Verwaltung" group (for example "sekretariat") and create calendars, lectures and events. The calendars can then be accessed using a student login (for example "student1", who is in the "TINF2021AI" group and can only see that calendar, if available).

The Auth URL provided below gives you access to the Keycloak dashboard, where the "admin" user can manage users and assign them to groups. In addition, the Grafana URL below gives you access to the Grafana dashboard, where the admin user can check the status of all containers.
Both Keycloak and Grafa can also be opened via the lecture calendar by clicking on the user image at the top right and selecting the desired application.

### Configurations

path to configs:

```path
./config/<container-name>/
```

> In the [docker-compose.yml](./docker-compose.yml) the containers are defined and in the [docker-compose.override.yml](./docker-compose.override.yml) the containers are configured.

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


## URLs

| Container | Url |
| --- | --- |
| Client | http://localhost/ |
| Keycloak | http://localhost/auth/ |
| Grafana | http://localhost/grafana/ |
| api | http://localhost/v1/api |
| api-swagger | http://localhost/swagger/ |


## Logins

| Username | Password | Gruppen | Kommentar |
| --- | --- | --- | --- |
| admin  | **74RuqICjDPQEFREmhIFaqRf6H** |   | Keycloak Admin |
| admin  | **74RuqICjDPQEFREmhIFaqRf6H** |  | Grafana Admin |
| User  | **User** |  | Grafana User |
| dev | **dev** | `Verwaltung`, `Instructors`, `TINF2022AI`, `TINF2021AI`, `TINF2020AI` | Development User |
| sekreteriat | **sekreteriat** | `Verwaltung`, `TINF2022AI`, `TINF2021AI`, `TINF2020AI` |
| dozent  | **dozent** | `Instructors`, `TINF2022AI`, `TINF2021AI`, `TINF2020AI` |
| student1  | **student1** | `TINF2021AI` |


## API

### Environment variables

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
  - `API_SWAGGER_CLIENT_SECRET` : The secret for the swagger client (`""`) [**Required**]
  - `API_SWAGGER_REDIRECT_URL` : The redirect URL for the OIDC server (`""`) [**Required**]
  - `API_USE_SWAGGER` : Enables the swagger open api documentation endpoint (`false`) [**Optional**]
  - `API_SWAGGER_CLIENT_ID` : The client id for the swagger client (`"calendar-api-swagger"`) [*Optional*]
  - `API_SWAGGER_AUTHORIZATION_URL` : Path to authentication on OIDC server (`"/protocol/openid-connect/auth"`) [*Optional*]
  - `API_SWAGGER_OIDC_TOKEN_URL` : Path to token on OIDC server (`"/protocol/openid-connect/token"`) [*Optional*]
  - `API_SWAGGER_OIDC_REFRESH_TOKEN_URL` : Path to token on OIDC server (`"/protocol/openid-connect/token"`) [*Optional*]
- Keycloak Api
  - `API_KEYCLOAK_REST_PASSWORD` : Password for admin account [**Required**]
  - `API_KEYCLOAK_BASE_URL` : URL to Keycloak service (`"http://localhost:8080"`) [*Optional*]
  - `API_KEYCLOAK_REST_USER` : Admin user name (`"admin"`) [*Optional*]
  - `API_KEYCLOAK_REALM` : The Keycloak Realm (`"Calendar"`) [*Optional*]
  - `API_KEYCLOAK_CALENDARS_GROUP_NAME` : The group name for Calendars (`"Semesters"`) [*Optional*]
  - `API_KEYCLOAK_INSTRUCTOR_GROUP_NAME` : The group name for instructors (`"Instructors"`) [*Optional*]
- Debug
  - `API_DEBUG_TEST_ENDPOINT_ENABLED` : Enable test endpoint (/test) (`"false"`) [*Optional*]
  - `API_DEBUG_TEST_ENDPOINT_POLICY` : The policy for the test endpoint mögliche werte: [`EDITOR` |  `VIEWER` | `EDITOR_VIEWER`] (`""`) [*Optional*]

## Client

### Build variables

- API
  - `VITE_API_HOST`: The host name for the rest api (`http://localhost:4000`) [**Required**]
  - `VITE_API_URL`: The api url (`/v1/api/`) [**Optional**]
- OIDC
  - `VITE_OIDC_URL`: The oidc server url (`""`) [**Required**]
  - `VITE_OIDC_REDIRECT_URL`: The redirect url to client (`""`) [**Required**]
  - `VITE_OIDC_AUTHORITY`: The url to authority endpoint, based on VITE_OIDC_URL  (`""`) [**Required**]
  - `VITE_OIDC_ACCOUNT_URL`: The url to account endpoint, based on VITE_OIDC_URL (`""`) [**Required**]
  - `VITE_OIDC_CLIENT_SECRET`: The oidc client secret (`""`) [**Required**]
  - `VITE_OIDC_AUTO_SIGN_IN`: Activate silent auto login (`false`) [**Optional**]
  - `VITE_QUERY_USE_DEVTOOL`: The enables the useQuery dev tools (`false`) [**Optional**]
