<template lang="html">
    <div class="image-crop-pane">
        <trail :items="['Generator', 'Crop Image']"
            class="trail"  @back="$emit('back')"/>
        <div class="main">
            <div class="editor">
                <img id="editor-image"/>
            </div>
            <button class="button crop-button" @click="cropImage()">Crop</button>
        </div>
    </div>
</template>

<script>
import Cropper from 'cropperjs'

import Trail from '../widgets/Trail'

export default {
    components: { Trail },
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

.image-crop-pane {
    height: 100%;
    display: flex;
    flex-direction: column;
    max-width: 112.0rem;
    margin: 0 auto;

    .trail {
        padding-top: 1rem;
    }

    .main {
        flex-grow: 1;
        display: flex;
        flex-direction: column;
        .flexbox-center-center;

        .editor {
            width: 30rem;
            height: 30rem;
            border: 1px solid #e3e6e8;
            border-radius: 1.5rem;
        }

        .crop-button {
            margin-top: 2rem;
        }
    }
}

.flexbox-center-center() {
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
}
</style>
