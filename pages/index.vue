<template>
    <div>
    </div>
</template>

<script setup>
import Keycloak from "keycloak-js";
const runtimeConfig = useRuntimeConfig()

const keycloak = new Keycloak({
    url: runtimeConfig.kcServerUrl,
    realm: runtimeConfig.kcRealmName,
    clientId: runtimeConfig.kcClientId
});

await keycloak.init({
    checkLoginIframe: false,
});

if (keycloak.authenticated) await navigateTo("/home");

keycloak.login({ redirectUri: `${runtimeConfig.domainUrl}/home` });
</script>
