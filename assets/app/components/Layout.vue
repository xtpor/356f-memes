<template>
    <div class="root">
        <header>
            <slot name="header"></slot>
        </header>
        <main>
            <slot></slot>
        </main>
        <footer>
            <slot name="footer"></slot>
        </footer>
    </div>
</template>

<style scoped>
header {
    height: 10rem;
}

.root, main {
    height: 100%;
}

main {
    margin-top: -10rem;
    padding-top: 10rem;
    padding-bottom: 5rem;
    min-height: 100vh;
}

footer {
    margin-top: -5rem;
    height: 5rem;
}
</style>
