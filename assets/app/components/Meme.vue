<template lang="html">
    <layout>
        <navigation slot="header" @logout="logout"></navigation>
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
                            <i class="fa fa-user-o" aria-hidden="true"></i>
                            Created by
                            <router-link :to="{ name: 'User', params: {id: user.username} }"
                                v-if="user && user.username">
                                {{ user.username }}
                            </router-link>
                            <span v-else>a guest</span>
                            <span v-if="meme">
                                <i class="fa fa-clock-o" aria-hidden="true"></i>
                                {{ formatFromNow(meme.created_at) }}
                            </span>
                        </div>
                    </div>
                </div>
                <div class="meme-image">
                    <img v-if="meme && meme.image" :src="`/archive/${meme.image}`"/>
                </div>
                <url-box class="url-box" v-if="meme" :url="`/archive/${meme.image}`"></url-box>
                <div class="likes">
                    <div class="likes-display">
                        <i class="fa fa-thumbs-up" aria-hidden="true"></i>
                        <span v-if="meme">{{ meme.num_likes }}</span>
                    </div>
                    <span v-if="!loginAs" class="please-login">Please
                        <router-link :to="{ name: 'SignIn' }">sign in</router-link>
                        to like
                    </span>
                    <button v-else-if="!liked" class="button" @click="like">Like</button>
                    <button v-else class="button button-outline" @click="unlike">Liked</button>
                </div>
            </div>
        </div>
        <app-footer slot="footer"></app-footer>
    </layout>
</template>

<script>
import { formatFromNow } from '../utils'
import account from '../account'
import rpc from '../rpc'

import Layout from './Layout'
import Navigation from './Navigation'
import AppFooter from './Footer'
import UrlBox from './widgets/UrlBox'

export default {
    components: { Layout, Navigation, AppFooter, UrlBox },
    data() {
        return {
            loginAs: null,
            liked: true,
            user: null,
            meme: null
        }
    },
    methods: {
        formatFromNow,
        logout() {
            this.loginAs = null
        },
        like() {
            let id = this.$route.params.id
            rpc.call("/rpc/image", "like", account.token(), id)
                .then(resp => {
                    if (resp.status === "ok") {
                        this.liked = true
                        return rpc.call("/rpc/image", "meme_info", id)
                    }
                })
                .then(resp => this.meme = resp.result)
        },
        unlike() {
            let id = this.$route.params.id
            rpc.call("/rpc/image", "unlike", account.token(), id)
                .then(resp => {
                    if (resp.status === "ok") {
                        this.liked = false
                        return rpc.call("/rpc/image", "meme_info", id)
                    }
                })
                .then(resp => this.meme = resp.result)
        }
    },
    mounted() {
        let memeId = this.$route.params.id
        this.loginAs = account.loginAs()

        rpc.call("/rpc/image", "meme_info", memeId)
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

                    if (this.loginAs) {
                        rpc.call("/rpc/image", "like_status", account.token(), memeId)
                            .then(resp => {
                                this.liked = resp.result
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

    .likes {
        .flex-row;

        .likes-display {
            margin-right: 1rem;
            border: 1px solid #e4e1e1;
            border-radius: 0.7rem;
            width: 8rem;
            height: 4rem;
            font-size: 1.8rem;
            text-align: center;
            vertical-align: middle;
            line-height: 3.6rem;
        }

        .please-login {
            vertical-align: middle;
            line-height: 3.6rem;
            font-size: 1.8rem;
        }
    }
}
</style>
