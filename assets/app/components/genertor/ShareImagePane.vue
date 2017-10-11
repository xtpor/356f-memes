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
                        <div class="button button-outline copy-button" @click="copyURL">
                            <div class="tooltip">Copy</div>
                            <i class="fa fa-files-o fa-2x" aria-hidden="true"></i>
                        </div>
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
    },
    methods: {
        copyURL() {
            let urlText = document.getElementById('url-text')
            urlText.select()
            let succeeded = document.execCommand('copy')
        }
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
                    padding-right: 3.6rem;
                    width: 50rem;
                }

                .copy-button {
                    position: relative;
                    margin-left: -3.4rem;
                    margin-bottom: 0;
                    padding-top: 0.3rem;
                    padding-left: 0.3rem;
                    padding-right: 0.3rem;
                    padding-bottom: 0.1rem;
                    height: 2.7rem;
                    line-height: 2.7rem;
                    vertical-align: middle;

                    .tooltip {
                        display: none;
                    }
                }

                .copy-button:hover {
                    .tooltip {
                        display: block;
                        border: 1px solid black;
                        background-color: black;
                        color: white;
                        border-radius: 0.3rem;
                        position: absolute;
                        left: -1rem;
                        right: -1rem;
                        top: -3rem;
                        bottom: 3rem;
                    }
                }

            }
        }
    }
}
</style>
