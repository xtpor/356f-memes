<template lang="html">
    <div class="url">
        <div class="button url-tag">URL</div>
        <input type="text" id="url-text" :value="normalizeURL(url)" readonly>
        <div class="button button-outline copy-button" @click="copyURL">
            <div class="tooltip">Copy</div>
            <i class="fa fa-files-o fa-2x" aria-hidden="true"></i>
        </div>
    </div>
</template>

<script>
export default {
    props: ["url"],
    methods: {
        copyURL() {
            let urlText = document.getElementById('url-text')
            urlText.select()
            let succeeded = document.execCommand('copy')
        },
        normalizeURL(url) {
            if (url.startsWith('/')) {
                let loc = window.location
                return `${loc.protocol}//${loc.host}${url}`
            } else {
                return url
            }
        }
    }
}
</script>

<style lang="less" scoped>
@import "../../css/_flex_helper.less";

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
</style>
