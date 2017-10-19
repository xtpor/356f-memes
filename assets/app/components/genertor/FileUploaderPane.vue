<template lang="html">
    <layout class="file-uploader-pane">
        <trail :items="['Generator', 'File Uploader']"
            slot="trail" @back="$emit('back')"/>

        <input id="upload" type="file" multiple="false"
                @change="chosenFile($event)"
                accept="image/*" style="display: none"/>
        <div class="uploader"
                @dragenter.stop.prevent
                @dragover.stop.prevent
                @drop.stop.prevent="dropFile($event)">
            <span class="drag-n-drop-text">Drop Image Here</span>
            <span class="upload-text" @click="promptFile">Choose File</span>
        </div>
    </layout>
</template>

<script>
import _ from 'lodash'

import Layout from './Layout'
import Trail from '../widgets/Trail'

const supportedTypes = [
    "image/gif",
    "image/jpeg",
    "image/png",
    "image/svg+xml",
]

export default {
    components: { Trail, Layout },
    methods: {
        promptFile() {
            let upload = document.getElementById('upload')
            upload.click()
        },
        chosenFile(e) {
            let upload = document.getElementById('upload')
            this.handleUpload(upload.files[0])
        },
        dropFile(e) {
            let dt = e.dataTransfer;
            let files = dt.files;
            this.handleUpload(files[0])
        },
        handleUpload(file) {
            if (_.includes(supportedTypes, file.type)) {
                let reader = new FileReader()
                reader.readAsDataURL(file)
                reader.onload = () => {
                    window.storage.rawImageData = reader.result
                    this.$emit('done')
                }
            } else {
                console.log('invalid file type')
            }
        }
    }
}
</script>

<style lang="less" scoped>
@import "../../css/_palatte.less";
@import "../../css/_flex_helper.less";

.uploader {
    .flex-center;

    border: 1px solid @palatte-primary;
    border-radius: 0.7rem;
    width: 30rem;
    height: 30rem;

    .drag-n-drop-text {
        font-size: 2.5rem;
    }

    .upload-text {
        font-size: 3rem;
        text-decoration: underline;
    }

    .upload-text:hover {
        font-size: 3rem;
        text-decoration: none;
        cursor: pointer;
    }
}
</style>
