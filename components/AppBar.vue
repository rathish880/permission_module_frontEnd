<template>
    <div class="navbar bg-base-300 flex justify-around sm:gap-8 w-full">
        <div class="flex-none">
            <button class="btn btn-square bg-transparent hover:bg-transparent border-transparent hover:border-transparent">
                <img src="/logo.png" alt="aurcc logo" class="w-12 h-12">
            </button>
        </div>
        <div class="text-center w-full flex justify-center">
            <label class="font-bold text-xl sm:text-2xl">
                Anna University Regional Campus Coimbatore
            </label>
        </div>
        <slot />
    </div>
</template>
