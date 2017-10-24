<template lang="html">
    <layout>
        <navigation slot="header"></navigation>
        <div class="not-found">
            <div class="text">
                <span class="title">404 Not Found</span><br />
                Maybe you can try another page
            </div>
        </div>
        <app-footer slot="footer"></app-footer>
    </layout>
</template>

<script>
import Layout from './Layout'
import Navigation from './Navigation'
import AppFooter from './Footer'

export default {
    components: { Layout, Navigation, AppFooter }
}
</script>

<style lang="less" scoped>
@import "../css/_flex_helper.less";

.not-found {
    align-self: stretch;
    width: 112rem;
    .flex-center;

    .text {
        font-size: 3rem;
        text-align: center;

        .title {
            font-size: 4rem;
            font-weight: bold;
        }
    }
}
</style>
