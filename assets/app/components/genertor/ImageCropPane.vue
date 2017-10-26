<template lang="html">
    <layout class="image-crop-pane">
        <trail :items="['Generator', 'Crop Image']"
           slot="trail"  @back="$emit('back')"/>

        <div class="editor">
            <img id="editor-image"/>
        </div>
        <button class="button crop-button" @click="cropImage()">Crop</button>
    </layout>
</template>

<script>
import Cropper from 'cropperjs'

import Layout from './Layout'
import Trail from '../widgets/Trail'

export default {
    components: { Trail, Layout },
    data () {
        return { cropper: null }
    },
    mounted () {
        let image = document.getElementById('editor-image')
        image.src = window.storage.rawImageData
        image.onload = () => {
            this.cropper = new Cropper(image, {
                aspectRatio: 1,
                viewMode: 1,
                background: false,
            });
        }
    },
    methods: {
        cropImage() {
            window.storage.sourceImageData =
                this.cropper.getCroppedCanvas().toDataURL()
            this.$emit('done')
        }
    }
}
</script>

<style lang="less" scoped>
@import "../../css/_palatte.less";
@import "../../css/_flex_helper.less";

.editor {
    width: 30rem;
    height: 30rem;
    border: 1px solid @palatte-border;
    border-radius: 1.5rem;
}

.crop-button {
    margin-top: 2rem;
}
</style>
