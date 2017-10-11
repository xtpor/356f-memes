<template lang="html">
    <div class="share-image-pane">
        <div class="main">
            <a :href="url"><canvas id="display" width="900" height="900"></canvas></a>
            <div class="sidebox">
                <div>
                    <div class="title">Done!</div>
                    <div class="text">
                        Share your amazing work to your friends.
                    </div>
                    <div class="url">
                        <div class="button url-tag">URL</div>
                        <input type="text" id="url-text" :value="url" readonly>
                    </div>
                </div>
                <div>
                    <button class="button button-outline">
                        Share it on Monkey's Dictionary
                    </button>
                    <button class="button">
                        Make another one
                    </button>
                </div>
            </div>
        </div>
    </div>
</template>

<script>

export default {
    data() {
        return { url: window.storage.finalImageURL }
    },
    mounted() {
        let canvas = document.getElementById('display')
        let ctx = canvas.getContext('2d')
        let image = new Image()
        image.src = window.storage.finalImageData
        image.onload = () => ctx.drawImage(image, 0, 0)
    }
}
</script>

<style lang="less" scoped>
@import "../../css/_flex_helper.less";

.share-image-pane {
    height: 100%;
    .flex-center;

    .main {
        .flex-row;

        #display {
            width: 35rem;
            height: 35rem;
        }

        .sidebox {
            margin-left: 3rem;
            .flex-column;
            justify-content: space-between;

            .title {
                font-size: 4rem;
            }

            .text {
                font-size: 2.1rem;
            }

            .url {
                margin-top: 1rem;
                display: flex;
                align-items: center;

                .url-tag {
                    .flex-center;
                    padding: 0 1rem;
                    margin-bottom: 0;
                    margin-right: -5.1rem;
                    height: 2.7rem;
                    z-index: 1;
                }

                #url-text {
                    padding-left: 5.5rem;
                    width: 50rem;
                }
            }
        }
    }
}
</style>
