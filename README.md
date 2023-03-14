# AU-SMART Nuxt Application

This repository is the source for the Web App located at [ausmart.aurcc.in](https://ausmart.aurcc.in).
This app is written in [NuxtJs](https://nuxt.com/), a javascript framework.


## Deployment

To deploy the server, clone the repository and create a container image using [Podman](https://podman.io/).

```bash
$ podman build -t ausmart .
... # Build logs

```

Next, run the build image with appropriate environment variables.

```bash
$ podman run -d --name ausmart \
    -e NUXT_KEYCLOAK_REALM_NAME=realm_name \
    -e NUXT_KEYCLOAK_AUTH_SERVER_URL=kcurl \
    -e NUXT_KEYCLOAK_CLIENT_ID=kccid \
    -e NUXT_AUSMART_DOMAIN_URL=ausmarturl \
    -e NUXT_FASTAPI_SERVER_URL=fasapiurl \
    -p 80:80
    ausmart
```

## Environment Variables 

The server needs many environment variables to work well.

| Name | Description |
|--------------------------|---------------------------------------------------------------------------------------------|
| `NUXT_KEYCLOAK_REALM_NAME` | Name of the Keycloak realm. |
| `NUXT_KEYCLOAK_AUTH_SERVER_URL` | URL of the Keycloak service. |
| `NUXT_KEYCLOAK_CLIENT_ID` | Client ID of the server in Keycloak. |
| `NUXT_AUSMART_DOMAIN_URL`| URL of this AU-SMART website |
| `NUXT_FASTAPI_SERVER_URL` | URL of the fastAPI backend server |

## Development

The following sections focus on developing the Nuxt application.

## Setup

Clone the repository [api.aurcc.in](git@gitlab.com:aurcc/api.aurcc.in.git) and install the dependencies mentioned in that project README.md file.

Clone this repository and make sure to install the dependencies:

```bash
# npm
npm install
```

## Development Server

Start the development server on http://localhost:3000

```bash
npm run dev
```

Check out the [deployment documentation](https://nuxt.com/docs/getting-started/deployment) for more information.
