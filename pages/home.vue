<template>
    <div class="mb-8">
        <AppBar class="sticky top-0 z-20">
            <div @click="logout()">
                <button class="btn btn-square btn-ghost">
                    <svg class="fill-zinc-600 scale-90" xmlns="http://www.w3.org/2000/svg" width="24" height="24"
                        viewBox="0 0 24 24">
                        <path d="M16 9v-4l8 7-8 7v-4h-8v-6h8zm-16-7v20h14v-2h-12v-16h12v-2h-14z" />
                    </svg>
                </button>
            </div>
        </AppBar>

        <div class="font-semibold text-center text-xl my-4">Report Page</div>

        <div class="flex flex-col gap-8 m-8 sm:px-35 lg:px-40">

            <div class="font-semibold text-xl">
                {{ currentUser == "Dean" ? "Select a duration: " : "Select a Period: " }}
            </div>

            <section v-if="currentUser == 'Dean'">
                <div class="flex flex-col sm:flex-row text-lg gap-2 sm:gap-8 sm:items-center">

                    <span class="flex justify-evenly gap-2 sm:gap-8 items-center">
                        <label for="from_date" class="w-1/4 sm:w-fit">From: </label>
                        <input type="date" id="from_date" v-model="from_date"
                            class="input input-bordered input-primary w-3/4 sm:w-full max-w-xs h-10">
                    </span>

                    <span class="flex justify-evenly gap-2 sm:gap-8 items-center">
                        <label for="to_data" class="w-1/4 sm:w-fit">To: </label>
                        <input type="date" id="to_date" v-model="to_date"
                            class="input input-bordered input-primary w-3/4 sm:w-full max-w-xs h-10">
                    </span>

                    <span class="flex justify-end">
                        <button class="btn btn-active min-w-24 btn-primary text-white btn-sm h-10 ml-4"
                            @click="get_reports()">See
                            Reports</button>
                    </span>
                </div>


                <section class="my-4">
                    <div class="overflow-x-auto w-full">
                        <table class="table table-compact w-full">
                            <!-- head -->
                            <thead>
                                <tr>
                                    <th>Class</th>
                                    <th>Date</th>
                                    <th>Period</th>
                                    <th>Reason</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr v-for="item in reports">
                                    <th class="pr-4">{{ String(item.reporter_group).replaceAll("/", " ").substring(9) }}
                                    </th>
                                    <td>{{ new Date(item.reported_on).toLocaleDateString() }}</td>
                                    <td>{{ item.period }}</td>
                                    <td>{{ item.details }}</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </section>
            </section>

            <section v-else class="flex flex-col gap-8">
                <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
                    <span v-for="(item, period_num) in periods">

                        <button type="button"
                            :class="{ 'btn-active btn-primary text-white': selectedPeriod == item.timing, 'btn-disabled': isDisable(item.hour, item.minute) }"
                            class="btn btn-outline btn-primary  flex flex-row gap-1 sm:w-44" tabindex="-1" role="button"
                            aria-disabled="true" @click="selectedPeriod = item.timing; period = period_num">

                            <span :class="{ 'text-amber-300 dark:text-amber-300': selectedPeriod == item.timing }"
                                class="px-3 font-bold text-amber-600">{{ period_num }}</span>
                            <span :class="{ 'text-white': selectedPeriod == item.timing }">{{ item.timing }}</span>
                        </button>

                    </span>
                </div>
                <div class="flex justify-center">
                    <textarea v-model="reason" class="textarea textarea-primary textarea-lg w-full "
                        :class="{ 'textarea-error': reason == '' & showWarnSymbol }"
                        placeholder="Enter a valid reason"></textarea>
                </div>

                <div class="flex justify-end">
                    <button class="btn btn-active min-w-24 btn-primary text-white" :class="{ 'loading': isLoading }"
                        @click="post_report()">Submit</button>
                </div>

                <div v-show="showMessage"
                    class="bg-warning text-black rounded-2xl h-12 items-center shadow-lg flex flex-row justify-center gap-2"
                    :class="{ 'bg-success': !showWarnSymbol }">
                    <svg v-show="showWarnSymbol" xmlns="http://www.w3.org/2000/svg"
                        class="stroke-current flex-shrink-0 h-6 w-6" fill="none" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                            d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
                    </svg>
                    <span>{{ toasMessage }}</span>
                </div>
            </section>

        </div>
    </div>
</template>

<script setup>
import Keycloak from "keycloak-js";
import { ref } from "vue";

const runtimeConfig = useRuntimeConfig()
const keycloak = new Keycloak({
    url: runtimeConfig.kcServerUrl,
    realm: runtimeConfig.kcRealmName,
    clientId: runtimeConfig.kcClientId
});

await keycloak.init({
    checkLoginIframe: false,
});

if (!keycloak.authenticated) await navigateTo("/");

const selectedPeriod = ref("")
const period = ref(0)
const reason = ref("")
const showMessage = ref(false)
const toasMessage = ref("")
const showWarnSymbol = ref(false)
const currentUser = ref("")
const isLoading = ref(false)

const today = ref(new Date())
const from_date = ref(today.value.toISOString().split("T")[0])

today.value.setDate(today.value.getDate() + 1)
const to_date = ref(today.value.toISOString().split("T")[0])

const reports = ref([])
const url = `${runtimeConfig.backendUrl}/ausmart/reports/`

const isDisable = (hour, minute) => {
    const date = new Date()

    // if starting time > current time
    //      disable button
    // if (date.getDay() == 0)
    //     return true
    if (Date.parse(`1/1/2020 ${hour}:${minute}:00`) > Date.parse(`1/1/2020 ${date.getHours()}:${date.getMinutes()}:00`)) {
        return true
    } else {
        return false
    }
}

const periods = { // hour and minute are for starting time of a period
    1: { timing: "09:10 - 10:00", hour: 9, minute: 10 },
    2: { timing: "10:00 - 10:50", hour: 10, minute: 0 },
    3: { timing: "11:10 - 12:00", hour: 11, minute: 10 },
    4: { timing: "12:00 - 12:50", hour: 12, minute: 0 },
    5: { timing: "01:50 - 02:40", hour: 13, minute: 50 },
    6: { timing: "02:40 - 03:30", hour: 14, minute: 40 },
    7: { timing: "03:40 - 04:30", hour: 15, minute: 40 },
}

const logout = () => keycloak.logout({ redirectUri: `${runtimeConfig.domainUrl}/` });

const post_report = async () => {

    if (keycloak.isTokenExpired()) await navigateTo("/")

    if (selectedPeriod.value != "" && reason.value != "") {
        isLoading.value = true
        showMessage.value = false

        await useFetch(url, {
            method: "POST",
            body: { period: period.value, details: reason.value },
            headers: { Authorization: "Bearer " + keycloak.token }
        }).then(({ data }) => {
            if (data.value == true) {
                selectedPeriod.value = ""
                reason.value = ""
                showWarnSymbol.value = false
                isLoading.value = false
                toasMessage.value = "Report submitter successfully!"
                showMessage.value = true
            }
        })

    } else {
        showWarnSymbol.value = true
        toasMessage.value = "All the details are required!"
        showMessage.value = true
    }
}

const get_reports = async () => {

    await useFetch(url, {
        method: "GET",
        query: {
            from_date: from_date.value,
            to_date: to_date.value,
        },
        headers: { Authorization: "Bearer " + keycloak.token }
    }).then(({ data }) => {
        reports.value = data.value
    })
}

if (keycloak.hasRealmRole("dean")) {
    currentUser.value = "Dean"
    get_reports()
}

</script>
