<template lang="html">
    <layout class="url-uploader-pane">
        <trail :items="['Generator', 'URL Uploader']"
            slot="trail"  @back="$emit('back')"/>
        <input class="search-bar" type="url" v-model:text="url"
            placeholder="Type the URL of the image here">
        <div :class="['status', statusClass]">{{ status }}</div>
    </layout>
</template>

<script>
import _ from 'lodash'
import rpc from '../../rpc'

import Layout from './Layout'
import Trail from '../widgets/Trail'

const urlPattern = /(http|https):\/\/(\w+:{0,1}\w*)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%!\-\/]))?/

export default {
    components: { Trail, Layout },
    data() {
        return { url: "", status: "", statusClass: "normal" }
    },
    watch: {
        url() {
            this.status = 'Waiting for you to finish typing ...'
            this.fetchImage()
        }
    },
    methods: {
        fetchImage: _.debounce(function () {
            let url = this.url;

            if (url === '') return
            if (!url.startsWith("http")) url = "http://" + url

            if (urlPattern.test(url)) {
                this.status = 'Fetching the image from the internet ...'
                this.statusClass = 'normal'

                rpc.call('/rpc', 'fetch', url)
                    .catch((error) => {
                        this.status = error.message
                        this.statusClass = 'error'
                    })
                    .then((resp) => {
                        this.statusClass = 'normal'
                        if (resp.error) {
                            this.status = resp.error
                        } else {
                            this.status = "done!"
                            window.storage.rawImageData = resp.data
                            this.$emit('done')
                        }
                    });
                } else {
                    this.status = 'Invalid URL'
                    this.statusClass = 'error'
                }
            }, 1000)
        }
    }
</script>

<style lang="less" scoped>
@import "../../css/_palatte.less";

.search-bar {
    max-width: 90rem;
    height: 5rem;
    font-size: 2.0rem;
}

.status {
    margin-top: 1rem;
    font-size: 2rem;
    height: 2rem;
}

.normal {
    color: @palatte-primary;
}

.error {
    color: #f17878;
}

</style>
