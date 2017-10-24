<template lang="html">
    <layout>
        <navigation slot="header"></navigation>
        <div class="meme-container">
            <div class="meme-main">
                <div class="heading">
                    <div class="icon">
                        <img v-if="user && user.icon" :src="`/archive/${user.icon}`" />
                        <img v-else src="/images/default-icon.svg" />
                    </div>
                    <div class="heading-right">
                        <span class="title">
                            <span v-if="meme && meme.title">{{ meme.title }}</span>
                            <span v-else>Untitled</span>
                        </span>
                        <div class="name">
                            Created by
                            <router-link :to="{ name: 'User', params: {id: user.username} }"
                                v-if="user && user.username">
                                {{ user.username }}
                            </router-link>
                            <span v-else>a guest</span>
                        </div>
                    </div>
                </div>
                <div class="meme-image">
                    <img v-if="meme && meme.image" :src="`/archive/${meme.image}`"/>
                </div>
                <url-box class="url-box" v-if="meme" :url="`/archive/${meme.image}`"></url-box>
            </div>
        </div>
        <app-footer slot="footer"></app-footer>
    </layout>
</template>

<script>
import rpc from '../rpc'

import Layout from './Layout'
import Navigation from './Navigation'
import AppFooter from './Footer'
import UrlBox from './widgets/UrlBox'

export default {
    components: { Layout, Navigation, AppFooter, UrlBox },
    data() {
        return {
            user: null,
            meme: null
        }
    },
    mounted() {
        rpc.call("/rpc/image", "meme_info", this.$route.params.id)
            .then(resp => {
                if (resp.status === "ok") {
                    console.log('fetched meme info ', resp.result)
                    this.meme = resp.result
                    if (this.meme.username) {
                        rpc.call("/rpc/account", "info", this.meme.username)
                            .then(resp => {
                                console.log('fetched user info', resp.result)
                                this.user = resp.result
                            })
                    }
                } else {
                    this.$router.push({ name: "PageNotFound" })
                }
            })
    }
}
</script>

<style lang="less" scoped>
@import "../css/_flex_helper.less";

.meme-container {
    width: 112.0rem;
}

.meme-main {
    width: 40rem;
    margin: 0 auto;
    display: flex;
    flex-direction: column;

    .heading {
        .flex-row;
        margin-top: 1rem;

        .icon {
            width: 7rem;
            height: 7rem;
            border: 1px solid #e4e1e1;
            border-radius: 0.5rem;
        }

        .heading-right {
            .flex-column;
            margin-left: 1rem;

            .title {
                font-size: 2.0rem;
                font-weight: bold;
            }

            .name {
            }
        }
    }

    .meme-image {
        margin-top: 1rem;
        border: 1px solid #e4e1e1;
        height: 40rem;
        width: 40rem;
    }

    .url-box {
        margin-bottom: 1rem;
    }
}
</style>
