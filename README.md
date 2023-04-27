# ausmart.aurcc.in

This repository is the source for the AU-SMART Web App [ausmart.aurcc.in](https://ausmart.aurcc.in).

## Design

This web app is written using [NuxtJs](https://nuxt.com/) javascript framework and [tailwindcss](https://tailwindcss.com/) with [daisyUI](https://daisyui.com/).

For user authentication, [Keycloak](https://www.keycloak.org/) is used.
To notify the Dean, a telegram bot called [AURCC bot](https://t.me/aurccbot) is used.

This server runs as [podman](https://podman.io/) container in the domain [ausmart.aurcc.in](https://ausmart.aurcc.in).

## Services

1. AU-SMART - Anna University Students' Monitoring And Reporting Tool. This web application is for students to report staff absence directly to the Dean.


## Getting Started

Clone this repository.

```bash
git clone git@gitlab.com:aurcc/ausmart.aurcc.in.git
```

Change the directory and build the container.

```bash
cd ausmart.aurcc.in
podman build -t ausmart .
```

## Environment Variables 

The server needs the following environment variables.

| Name | Description |
|--------------------------|---------------------------------------------------------------------------------------------|
| `NUXT_KEYCLOAK_REALM_NAME` | Name of the Keycloak realm. |
| `NUXT_KEYCLOAK_AUTH_SERVER_URL` | URL of the Keycloak service. |
| `NUXT_KEYCLOAK_CLIENT_ID` | Client ID of the server in Keycloak. |
| `NUXT_AUSMART_DOMAIN_URL`| URL of this AU-SMART website |
| `NUXT_FASTAPI_SERVER_URL` | URL of the fastAPI backend server |

Next, run the image with appropriate environment variables.

```bash
$ podman run -d --name ausmart \
    -e NUXT_KEYCLOAK_REALM_NAME=realm_name \
    -e NUXT_KEYCLOAK_AUTH_SERVER_URL=kcurl \
    -e NUXT_KEYCLOAK_CLIENT_ID=kccid \
    -e NUXT_AUSMART_DOMAIN_URL=ausmarturl \
    -e NUXT_FASTAPI_SERVER_URL=fasapiurl \
    -p 9000:3000
    ausmart
```

## Miscellaneous

Please refer to followint documentation for any references.
    - [NuxtJs](https://nuxt.com)
    - [tailwindcss](https://tailwindcss.com/)
    - [daisyUI](https://daisyui.com/)
    - [keycloak](https://www.keycloak.org/)
    - [podman](https://podman.io/)
