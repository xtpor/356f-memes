<template lang="html">
    <layout>
        <navigation slot="header"></navigation>
        <selection-pane v-if="pane === 'selection'" @click="handle($event)"/>
        <url-uploader-pane v-if="pane === 'url-uploader'"/>
        <app-footer slot="footer"></app-footer>
    </layout>
</template>

<script>
import Layout from './Layout'
import Navigation from './Navigation'
import AppFooter from './Footer'

import SelectionPane from './genertor/SelectionPane'
import UrlUploaderPane from './genertor/UrlUploaderPane'

export default {
    components: { Layout, Navigation, AppFooter, SelectionPane, UrlUploaderPane },
    methods: {
        handle(nextPane) {
            this.pane = nextPane
        }
    },
    data: () => ({
        pane: 'selection'
    })
}
</script>

<style lang="less" scoped>

</style>
