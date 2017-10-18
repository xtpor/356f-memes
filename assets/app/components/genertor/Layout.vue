<template lang="html">
    <div class="generator-layout">
        <slot name="trail"></slot>
        <div class="main">
            <slot></slot>
        </div>
    </div>
</template>

<style lang="less">
@import "../../css/_flex_helper.less";

.generator-layout {
    align-self: stretch;
    display: flex;
    flex-direction: column;
    max-width: 112.0rem;
    margin: 0 auto;

    .trail {
        margin-top: 1rem;
    }

    .main {
        flex-grow: 1;
        .flex-center;
    }
}
</style>
