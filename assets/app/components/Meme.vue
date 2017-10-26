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
                <div class="add-comment">
                    <span v-if="!loginAs" class="please-login">Please
                        <router-link :to="{ name: 'SignIn' }">sign in</router-link>
                        to comment
                    </span>
                    <div class="comment-box" v-else>
                        <h2 class="comment-heading">Comment</h2>
                        <textarea class="comment-area" v-model="content"></textarea>
                        <button class="button button-outline" @click="comment">comment</button>
                        <span v-if="commentError" class="error-message">{{ commentError }}</span>
                        <span v-if="commentMessage" class="info-message">{{ commentMessage }}</span>
                    </div>
                </div>
                <div class="comments" v-if="meme">
                    <div class="comment" v-for="comment in meme.comments">
                        <div class="comment-user">
                            <router-link :to="{ name: 'User', params: { id: comment.username} }">
                            <img v-if="icons[comment.username]" class="icon"
                                :src="`/archive/${icons[comment.username]}`"/>
                            <img v-else
                                class="icon" src="/images/default-icon.svg"/>
                            </router-link>
                            <router-link class="username" :to="{ name: 'User', params: { id: comment.username} }">
                                {{ comment.username }}
                            </router-link>
                            <span>
                                <i class="fa fa-clock-o" aria-hidden="true"></i>
                                {{ formatFromNow(comment.created_at) }}
                            </span>
                        </div>
                        <div class="comment-content">{{ comment.content }}</div>
                    </div>
                </div>
            </div>
        </div>
        <app-footer slot="footer"></app-footer>
    </layout>
</template>

<script>
import _ from 'lodash'
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
            meme: null,
            icons: {},
            content: "",
            commentError: "",
            commentMessage: "",
        }
    },
    methods: {
        formatFromNow,
        logout() {
            this.loginAs = null
        },
        comment() {
            let id = this.$route.params.id
            rpc.call("/rpc/image", "comment", account.token(), id, this.content)
                .then(resp => {
                    if (resp.status === "ok") {
                        this.commentError = ""
                        this.commentMessage = "Added your comment"
                        this.content = ""
                        return rpc.call("/rpc/image", "meme_info", id)
                    } else {
                        this.commentError = resp.reason
                        this.commentMessage = ""
                    }
                })
                .then(resp => {
                    this.meme = resp.result
                    this.reloadIcons()
                })
        },
        reloadIcons() {
            _.each(_.uniq(_.map(this.meme.comments, "username")), uname => {
                rpc.call("/rpc/account", "info", uname).then(resp => {
                    this.$set(this.icons, uname, resp.result.icon)
                })
            })
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

                    this.reloadIcons()
                } else {
                    this.$router.push({ name: "PageNotFound" })
                }
            })
    }
}
</script>

<style lang="less" scoped>
@import "../css/_utils.less";
@import "../css/_flex_helper.less";
@import "../css/_palatte.less";

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
            .square(7rem);
            border: 1px solid @palatte-border;
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
        border: 1px solid @palatte-border;
        .square(40rem);
    }

    .url-box {
        margin-bottom: 1rem;
    }

    .likes {
        .flex-row;

        .likes-display {
            margin-right: 1rem;
            border: 1px solid @palatte-border;
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

    .add-comment {
        .comment-box {
            .flex-column;
            .comment-heading {
                margin-bottom: 0.5rem;
                font-size: 1.8rem;
            }

            .comment-area {
                height: 10rem;
                margin-bottom: 0.5rem;
            }

            .error-message {
                color: @palatte-failure;
            }

            .info-message {
                color: @palatte-success;
            }
        }
    }

    .comments {
        margin-bottom: 1rem;
        .comment {
            margin-top: 1.5rem;

            .comment-user {
                .flex-row;
                align-items: flex-start;
                margin-bottom: 0.7rem;

                .icon {
                    .square(4rem);
                }

                .username {
                    margin-left: 1rem;
                    margin-right: 1rem;
                    font-size: 1.7rem;
                    font-weight: bold;
                    color: @palatte-primary;
                }

                .username:hover {
                    text-decoration: underline;
                }
            }

            .comment-content {
                white-space: pre-wrap;
            }
        }
    }
}
</style>
