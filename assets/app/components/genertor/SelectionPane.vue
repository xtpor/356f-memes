<template lang="html">
    <div class="upload-methods">
        <div class="item-frame" @click="$emit('jump', 'album-uploader')">
            <div class="item-icon icon-album"></div>
            <div class="item-title">Album</div>
            <div class="item-desc">
                Choose from our image album
            </div>
        </div>
        <div class="item-frame" @click="$emit('jump', 'file-uploader')">
            <div class="item-icon icon-upload"></div>
            <div class="item-title">Upload</div>
            <div class="item-desc">
                Upload and use your own image
            </div>
        </div>
        <div class="item-frame" @click="$emit('jump', 'url-uploader')">
            <div class="item-icon icon-internet"></div>
            <div class="item-title">URL</div>
            <div class="item-desc">
                Use an image from the Internet
            </div>
        </div>
    </div>
</template>

<script>
export default {
}
</script>

<style lang="less">
@import "../../css/_palatte.less";

@icon-size: 14rem;

.upload-methods {
    height: 100%;
    display: flex;
    justify-content: center;
    align-items: center;

    .item-frame:hover {
        border: 1.0px solid @palatte-secondary;
    }

    .item-frame {
        cursor: pointer;
    }

    .item-frame {
        border: 1px solid #babcbe;
        margin: 1.5rem;
        width: 23rem;
        height: 30rem;
        padding: 3rem 2rem;
        border-radius: 1.1rem;
        display: flex;
        flex-direction: column;
        justify-content: space-between;
        align-items: center;

        .item-icon {
            // border: 1px solid black;
            width: @icon-size;
            height: @icon-size;
        }

        .icon-album, .icon-upload, .icon-internet {
            background-size: @icon-size @icon-size;
        }

        .icon-album {
            background-image: url("/images/icon-album.svg");
        }

        .icon-upload {
            background-image: url("/images/icon-upload.svg");
        }

        .icon-internet {
            background-image: url("/images/icon-internet.svg");
        }

        .item-title {
            padding-top: 1.3rem;
            font-size: 1.7em;
        }

        .item-desc {
            font-size: 0.90em;
            white-space: nowrap;
        }
    }
}
</style>
