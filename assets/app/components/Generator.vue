<template lang="html">
    <layout>
        <navigation slot="header"></navigation>

        <selection-pane v-if="pane === 'selection'" @jump="jump"/>

        <url-uploader-pane v-if="pane === 'url-uploader'"
            @done="jump('image-crop')"
            @back="jump('selection')"/>

        <image-crop-pane v-if="pane === 'image-crop'"
            @done="jump('add-text')"
            @back="jump('selection')"/>

        <add-text-pane v-if="pane === 'add-text'"
            @done="jump('share-image')"
            @back="jump('selection')"/>

        <share-image-pane v-if="pane === 'share-image'"/>

        <app-footer slot="footer"></app-footer>
    </layout>
</template>

<script>
import Layout from './Layout'
import Navigation from './Navigation'
import AppFooter from './Footer'

import SelectionPane from './genertor/SelectionPane'
import UrlUploaderPane from './genertor/UrlUploaderPane'
import ImageCropPane from './genertor/ImageCropPane'
import AddTextPane from './genertor/AddTextPane'
import ShareImagePane from './genertor/ShareImagePane'

export default {
    components: { Layout, Navigation, AppFooter, SelectionPane,
                  UrlUploaderPane, ImageCropPane, AddTextPane,
                  ShareImagePane },
    methods: {
        jump(nextPane) {
            this.pane = nextPane
        }
    },
    data: () => ({
        pane: 'selection'
    }),
}
</script>

<style lang="less" scoped>

</style>
