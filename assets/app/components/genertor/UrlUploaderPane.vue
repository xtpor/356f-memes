<template lang="html">
    <div class="url-uploader-pane">
        <div class="subheader">
            <button class="button button-outline">back</button>
            <span class="trail">
                Generator
                <span class="seperator"> > </span>
                URL Uploader
            </span>
        </div>
        <div class="main" spellcheck="false">
            <input class="search-bar" type="url" v-model:text="url"
                placeholder="Type the URL of the image here">
            <div :class="['status', statusClass]">{{ status }}</div>
        </div>
    </div>
</template>

<script>
import _ from 'lodash'
import axios from 'axios'

const urlPattern = /(http|https):\/\/(\w+:{0,1}\w*)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%!\-\/]))?/

export default {
    data() {
        return { url: "", status: "", statusClass: "normal" }
    },
    watch: {
        url() {
            this.status = 'typing ...'
            if (this.url !== '') {
                this.fetchImage()
            }
        }
    },
    methods: {
        fetchImage: _.debounce(function () {
            if (!this.url.startsWith("http")) {
                this.url = "http://" + this.url
            }

            if (urlPattern.test(this.url)) {
                this.status = 'fetching ...'
                this.statusClass = 'normal'

                axios.get(this.url)
                    .then((response) => {
                        this.status = this.url + " oh!"
                        this.statusClass = 'normal'
                    })
                    .catch((error) => {
                        this.statusClass = 'error'
                        if (error.response) {
                            this.status = 'oh my god'
                            console.log(error.response.data);
                            console.log(error.response.status);
                            console.log(error.response.headers);
                        } else if (error.request) {
                            console.log(error.request);
                            this.status = 'Invalid address'
                        } else {
                            this.status = 'Unexpected error :('
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

<style lang="less">
@import "../../css/_palatte.less";

.url-uploader-pane {
    height: 100%;
    display: flex;
    flex-direction: column;
    max-width: 112.0rem;
    margin: 0 auto;

    .subheader {
        padding-top: 1rem;

        .trail {
            margin-left: 1rem;
            font-size: 2.0rem;

            .seperator {
                font-size: 2.5rem;
            }
        }
    }

    .main {
        flex-grow: 1;
        .flexbox-center-center;

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
    }

}

.flexbox-center-center() {
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
}

</style>
