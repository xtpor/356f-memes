<template lang="html">
    <layout>
        <navigation slot="header"></navigation>

        <selection-pane class="item" v-if="pane === 'selection'" @jump="jump"/>

        <url-uploader-pane v-if="pane === 'url-uploader'" class="item"
            @done="jump('image-crop')"
            @back="jump('selection')"/>

        <image-crop-pane v-if="pane === 'image-crop'" class="item"
            @done="jump('add-text')"
            @back="jump('selection')"/>

        <add-text-pane v-if="pane === 'add-text'" class="item"
            @done="jump('share-image')"
            @back="jump('selection')"/>

        <share-image-pane v-if="pane === 'share-image'" class="item"/>

        <file-uploader-pane v-if="pane === 'file-uploader'" class="item"
            @done="jump('image-crop')"
            @back="jump('selection')"/>

        <album-uploader-pane v-if="pane === 'album-uploader'" class="item"
            @done="jump('image-crop')"
            @back="jump('selection')"/>

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
import FileUploaderPane from './genertor/FileUploaderPane'
import AlbumUploaderPane from './genertor/AlbumUploaderPane'

export default {
    components: { Layout, Navigation, AppFooter, SelectionPane,
                  UrlUploaderPane, ImageCropPane, AddTextPane,
                  ShareImagePane, FileUploaderPane, AlbumUploaderPane },
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
.item {
    width: 100%;
}
</style>
