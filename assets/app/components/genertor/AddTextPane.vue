<template lang="html">
    <layout class="add-text-pane">
        <trail :items="['Generator', 'Add Text']"
            slot="trail"  @back="$emit('back')"/>

        <input class="title-input" type="text" placeholder="Title" v-model="title">
        <div class="editor-box">
            <canvas id="editor" width="900" height="900"/>
            <div class="inputs">
                <div class="item">
                    <div class="item-name">Upper Text</div>
                    <textarea v-model="upperText"></textarea>
                </div>
                <div class="item">
                    <div class="item-name">Lower Text</div>
                    <textarea v-model="lowerText"></textarea>
                </div>
            </div>
        </div>
        <button class="button" @click="done">
            upload
        </button>
    </layout>
</template>

<script>
import _ from 'lodash'
import account from '../../account'
import rpc from '../../rpc'

import Layout from './Layout'
import Trail from '../widgets/Trail'

const config = {
    padding: 0.05, // percent
    maximumLines: 6,
    charsLimit: 140,
    fallbackFontSize: 50,
}

const schemes = [
    { fontSize: 160, maximumLines: 1 },
    { fontSize: 150, maximumLines: 1 },
    { fontSize: 140, maximumLines: 1 },
    { fontSize: 130, maximumLines: 1 },
    { fontSize: 125, maximumLines: 2 },
    { fontSize: 120, maximumLines: 2 },
    { fontSize: 110, maximumLines: 2 },
    { fontSize: 100, maximumLines: 2 },
    { fontSize: 90, maximumLines: 3 },
    { fontSize: 85, maximumLines: 3 },
    { fontSize: 80, maximumLines: 4 },
    { fontSize: 70, maximumLines: 5 },
    { fontSize: 60, maximumLines: 3 },
]

function renderMemesText(canvas, upperText, lowerText, schemes, config) {
    const ctx = canvas.getContext('2d', {alpha: false})
    const padding = config.padding * canvas.height

    ctx.fillStyle = 'white'
    ctx.lineWidth = 3;
    ctx.strokeStyle = 'black'
    ctx.textAlign = 'center'

    function drawLine(text, y) {
        ctx.fillText(text, canvas.width / 2, y)
        ctx.strokeText(text, canvas.width / 2, y)
    }

    function extractLines(text) {
        return _.map(text.split('\n'), line => line.trim())
    }

    function setSuitableFontSize(lines) {
        let result = _.find(schemes, scheme => {
            if (lines.length > scheme.maximumLines) {
                return false;
            } else {
                ctx.font = `${scheme.fontSize}px Impact`
                return _.every(lines, l => {
                    let textWidth = ctx.measureText(l).width
                    return canvas.width - textWidth >= padding
                })
            }
        })

        if (result) {
            return result.fontSize
        } else {
            ctx.font = `${config.fallbackFontSize}px Impact`
            return config.fallbackFontSize
        }
    }

    function drawUpperText() {
        let lines = extractLines(upperText)
        let px = setSuitableFontSize(lines)
        ctx.textBaseline = 'top'
        _.each(lines, (l, index) => {
            drawLine(l, (padding / 2) + index * px)
        })
    }

    function drawLowerText() {
        let lines = extractLines(lowerText)
        let px = setSuitableFontSize(lines)
        ctx.textBaseline = 'bottom'
        _.reverse(lines)
        _.each(lines, (l, index) => {
            drawLine(l, canvas.height - ((padding / 2) + index * px))
        })
    }

    drawUpperText()
    drawLowerText()
}


export default {
    components: { Trail, Layout },
    data() {
        return {
            title: "",
            upperText: "",
            lowerText: "",
            image: null,
            sent: false,
        }
    },
    watch: {
        upperText() {
            this.render()
        },
        lowerText() {
            this.render()
        }
    },
    methods: {
        render() {
            let canvas = this.canvas;
            let ctx = canvas.getContext('2d', {alpha: false})
            let image = this.image

            let ratio = canvas.width / image.width

            ctx.clearRect(0, 0, canvas.width, canvas.height)
            ctx.save()
            ctx.translate(canvas.width / 2, canvas.height / 2)
            ctx.scale(ratio, ratio)
            ctx.drawImage(image, -image.width / 2, -image.height / 2)
            ctx.restore()

            renderMemesText(canvas, this.upperText.toUpperCase(),
                            this.lowerText.toUpperCase(), schemes, config)
        },
        done: function () {
            if (!this.sent) {
                this.sent = true
                let dataURL = this.canvas.toDataURL()
                window.storage.finalImageData = dataURL

                rpc.call('/rpc/image', 'upload_meme', account.token(), this.title, dataURL)
                    .then(resp => {
                        if (resp.status === "ok") {
                            console.log(resp.result)
                            this.$router.push({ name: "Meme", params: { id: resp.result }})
                        }
                    })
            }
        }
    },
    mounted() {
        let image = this.image = new Image()
        image.src = window.storage.sourceImageData
        image.onload = () => {
            this.canvas = document.getElementById('editor')
            this.render()
        }
    }
}
</script>

<style lang="less" scoped>
@import "../../css/_utils.less";
@import "../../css/_flex_helper.less";
@import "../../css/_palatte.less";

.title-input {
    width: 72rem;
    height: 4.5rem;
    margin-bottom: 1.5rem;
    font-size: 2rem;
}

.editor-box {
    .flex-row;

    #editor {
        .square(30rem);
        border: 1px solid @palatte-primary;
        border-radius: 0.2rem;
    }

    .inputs {
        .flex-column;
        margin-left: 2rem;
        justify-content: space-between;

        .item {
            .item-name {
                font-size: 2.0rem;
            }

            textarea {
                width: 40rem;
                height: 11rem;
                resize: none;
            }
        }
    }
}

button {
    margin-top: 1.5rem;
    font-size: 1.0rem;
}
</style>
