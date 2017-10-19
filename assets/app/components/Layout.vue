<template>
    <div class="root">
        <slot name="header"></slot>
        <div class="main">
            <slot></slot>
        </div>
        <footer>
            <slot name="footer"></slot>
        </footer>
    </div>
</template>

<style lang="less" scoped>
@footer-height: 5rem;

.root {
    display: flex;
    flex-direction: column;

    position: relative;
    min-height: 100%;
    width: 112.0rem;
    margin: 0 auto;
}

.main {
    flex-grow: 1;

    display: flex;

    padding-bottom: @footer-height;
}

footer {
    position: absolute;
    bottom: 0;
    left: 0;
    width: 100%;
    height: @footer-height;
}
</style>
