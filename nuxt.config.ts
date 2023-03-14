// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
    modules: ['@nuxtjs/tailwindcss'],
    app: {
        head: {
            link: [{ rel: 'icon', href: 'favicon.ico' }],
            meta: [{ "name": "viewport", "content": "width=device-width, user-scalable=no" }],
        }
    },
    ssr: false,
    runtimeConfig: {
        public: {
            kcRealmName:'',
            kcServerUrl:'',
            kcClientId:'',
            domainUrl:'',
            backendUrl:''
        }
    }
})
