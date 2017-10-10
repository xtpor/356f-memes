<template lang="html">
    <div class="image-cropper">
        <canvas :id="id" width="900" height="900"
            :style="cursorType"
            @mousedown="handleMouseDown($event)"
            @mouseup="handleMouseUp($event)"
            @mousemove="handleMouseMove($event)"></canvas>
        <button class="button">Crop</button>
    </div>
</template>

<script>
import _ from 'lodash'

function withinRadius({x: x1, y: y1}, {x: x2, y: y2}, r) {
    if (typeof x1 !== 'number') console.log("x1 is not number")
    if (typeof x2 !== 'number') console.log("x2 is not number")
    if (typeof y1 !== 'number') console.log("y1 is not number")
    if (typeof y2 !== 'number') console.log("y2 is not number")
    return (x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2) <= r * r
}

export default {
    data() {
        return {
            image: null,
            ready: false,
            id: Math.random().toString(36), // generate random id

            ratio: undefined,

            widthMaxOffset: undefined,
            heightMaxOffset: undefined,

            widthOffset: 0,
            heightOffset: 0,

            boxOffsetX: 0.05,
            boxOffsetY: 0.15,
            boxSize: 0.7,

            mouseX: 0,
            mouseY: 0,
            x: 0,
            y: 0,

            selecting: null,
            cachedOffsetX: 0.05,
            cachedOffsetY: 0.05,
            cachedSize: 0.5,
            cachedX: 0,
            cachedY: 0,

            cursorType: 'normal'
        }
    },
    computed: {
        canvas() {
            return document.getElementById(this.id)
        },
        ctx() {
            return this.canvas.getContext('2d')
        },
        corners() {
            const [x1, y1] = [this.boxOffsetX * this.canvas.width,
                            this.boxOffsetY * this.canvas.height]
            const [x3, y3] = [x1 + this.boxSize * this.canvas.width,
                              y1 + this.boxSize * this.canvas.height]
            return {x1, y1, x3, y3}
        },
    },
    watch: {
        widthOffset: function () {
            this.render();
        },
        heightOffset: function () {
            this.render();
        },
        boxOffsetX: function () {
            this.render();
        },
        boxOffsetY: function () {
            this.render();
        },
    },
    methods: {
        render() {
            const canvas = document.getElementById(this.id)
            const ctx = canvas.getContext('2d')
            const img = this.image

            ctx.clearRect(0, 0, canvas.width, canvas.height)

            ctx.save()

            ctx.translate(canvas.width / 2, canvas.height / 2)
            ctx.translate(canvas.width * this.widthOffset,
                          canvas.height * this.heightOffset)

            ctx.scale(this.ratio, this.ratio)
            ctx.drawImage(img, -img.width / 2, -img.height / 2)

            ctx.restore()

            ctx.strokeStyle = '#353c42'
            ctx.lineWidth = 9.0

            this.renderBox(canvas)

            ctx.strokeStyle = 'white'
            ctx.lineWidth = 7.5

            this.renderBox(canvas)

            _.each(this.computeEndpoints(), point => {
                this.drawDot(point[0], point[1])
            })
        },
        renderBox(canvas) {
            const ctx = canvas.getContext('2d')
            ctx.strokeRect(this.boxOffsetX * canvas.width,
                           this.boxOffsetY * canvas.height,
                           this.boxSize * canvas.width,
                           this.boxSize * canvas.height)
        },
        drawDot(x, y, radius) {
            this.ctx.beginPath();
            this.ctx.arc(x, y, 17, 0, 2 * Math.PI);

            this.ctx.strokeStyle = '#353c42'
            this.ctx.lineWidth = 1.0
            this.ctx.setLineDash([])

            this.ctx.fillStyle = 'rgb(229, 237, 240)'

            this.ctx.fill();
            this.ctx.stroke();
        },
        computeEndpoints() {
            const canvas = document.getElementById(this.id)
            const {x1, y1, x3, y3} = this.corners
            const [x2, y2] = [(x1 + x3) / 2, (y1 + y3) / 2]
            return [
                [x1, y1], [x2, y1], [x3, y1],
                [x1, y2],           [x3, y2],
                [x1, y3], [x2, y3], [x3, y3]
            ]
        },
        handleMouseDown(e) {
            this.selecting = this.pointingAt(this.mouseX, this.mouseY)

            this.cachedOffsetX = this.boxOffsetX
            this.cachedOffsetY = this.boxOffsetY
            this.cachedSize = this.boxSize

            this.cachedX = this.x
            this.cachedY = this.y
        },
        handleMouseUp(e) {
            this.selecting = null
        },
        handleMouseMove(e) {
            let rect = this.canvas.getBoundingClientRect()
            let scaleX = this.canvas.width / rect.width
            let scaleY = this.canvas.height / rect.height

            this.mouseX = (e.clientX - rect.left) * scaleX
            this.mouseY = (e.clientY - rect.top) * scaleY

            this.x = this.mouseX / this.canvas.width
            this.y = this.mouseY / this.canvas.height

            let pendingOffsetX, pendingOffsetY, pendingSize;

            if (this.selecting == 'inside') {
                pendingOffsetX = this.x + this.cachedOffsetX - this.cachedX
                pendingOffsetY = this.y + this.cachedOffsetY - this.cachedY
                pendingSize = this.boxSize
            } else if (this.selecting === 0) {
                let cx = this.cachedOffsetX + this.cachedSize
                let cy = this.cachedOffsetY + this.cachedSize

                let w = cx - this.x
                let h = cy - this.y

                console.log('w', w, 'h', h)

                if (w > h) {
                    pendingOffsetX = cx - w
                    pendingOffsetY = cy - w
                    pendingSize = w
                } else {
                    pendingOffsetX = cx - h
                    pendingOffsetY = cy - h
                    pendingSize = h
                }
            }

            // if the changed value is within the bounds
            if (pendingOffsetX > 0 && pendingOffsetY > 0 &&
                pendingOffsetX + pendingSize < 1 &&
                pendingOffsetY + pendingSize < 1 &&
                pendingSize > 0.1) {
                // commit the value
                this.boxOffsetX = pendingOffsetX
                this.boxOffsetY = pendingOffsetY
                this.boxSize = pendingSize
            } else {
                // discard the value
            }
        },
        pointingAt(x, y) {
            const radius = 20;
            let {x1, y1, x3, y3} = this.corners
            let endpoints = this.computeEndpoints()

            let index = _.findIndex(endpoints, ep => {
                let endpoint = {x: ep[0], y: ep[1]}
                if (withinRadius(endpoint, {x, y}, 20)) {
                    return true
                } else {
                    return false
                }
            })

            if (index !== -1) {
                return index
            } else if (x1 <= x && x <= x3 && y1 <= y && y <= y3) {
                return 'inside'
            } else {
                return 'outside'
            }
        },

        setCenter(cx, cy) {
            this.boxOffsetX = cx - (this.boxSize / 2)
            this.boxOffsetY = cy - (this.boxSize / 2)
        }
    },
    mounted() {
        this.image = new Image()
        this.image.src = window.storage.image
        this.image.onload = () => {
            this.ready = true

            const canvas = document.getElementById(this.id)
            const ctx = canvas.getContext('2d')

            const [cw, ch] = [canvas.width, canvas.height];
            const [iw, ih] = [this.image.width, this.image.height]

            if (iw > ih) {
                this.ratio = ch / ih
            } else {
                this.ratio = cw / iw
            }

            this.widthMaxOffset = (iw * this.ratio - cw) / (cw * 2)
            this.heightMaxOffset = (ih * this.ratio - ch) / (ch * 2)

            console.log(this.widthMaxOffset, this.heightMaxOffset)

            window.cropPane = this

            this.render()
        }
    }
}
</script>

<style lang="less">

.image-cropper {
    display: flex;
    flex-direction: column;
    align-items: center;

    canvas {
        border: 1px solid #556069;
        border-radius: 1.2rem;
        width: 35rem;
        height: 35rem;
        cursor: pointer;
    }

    button {
        margin-top: 1.5rem;
        width: 15rem;
    }
}

</style>
