<template lang="html">
    <layout>
        <navigation slot="header"></navigation>
        <div class="trends">
            <h1>Trends</h1>
            <div class="buttons">
                <button v-for="type in types"
                    :class="type === $route.params.type ? ['button'] : ['button', 'button-outline']"
                    @click="switchTo(type)">
                    {{ type.replace(/_/g, " ") }}
                </button>
            </div>
            <div class="default-message" v-if="memes.length === 0">
                <h2>No trends to show :(</h2>
            </div>
            <div class="trends-grid">
                <div class="meme" v-for="meme in memes">
                    <div class="image">
                        <img :src="imageURL(meme.image)"/>
                    </div>
                    <div class="user-info fx-row">
                        <div class="icon">
                            <img v-if="meme.icon" :src="imageURL(meme.icon)" />
                            <img v-else src="/images/default-icon.svg" />
                        </div>
                        <div class="right fx-col">
                            <router-link class="title" :to="{ name: 'Meme', params: { id: meme.id } }">
                                {{ meme.title || "Untitled" }}
                            </router-link>
                            <div class="info-bar">
                                <i class="fa fa-user" aria-hidden="true"></i>
                                <router-link v-if="meme.username"
                                    :to="{ name: 'User', params: { id: meme.username} }">
                                    {{ meme.username }}
                                </router-link>
                                <span v-else>guest</span>
                                <i class="fa fa-clock-o" aria-hidden="true"></i>
                                {{ formatFromNow(meme.created_at + 'Z') }}
                                <i class="fa fa-thumbs-up" aria-hidden="true"></i>
                                {{ meme.likes }}
                                <i class="fa fa-comments" aria-hidden="true"></i>
                                {{ meme.comments }}
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <app-footer slot="footer"></app-footer>
    </layout>
</template>

<script>
import _ from 'lodash'
import { imageURL, formatFromNow } from '../utils'
import rpc from '../rpc'

import Layout from './Layout'
import Navigation from './Navigation'
import AppFooter from './Footer.vue'

export default {
    components: { Layout, Navigation, AppFooter },
    data() {
        return {
            memes: [],
            types: ["newest",
                    "popular_today",
                    "popular_this_week",
                    "popular_this_year"]
        }
    },
    methods: {
        imageURL, formatFromNow,
        loadTrends(type) {
            rpc.call("/rpc/trends", type).then(({result: memes}) => {
                this.memes = memes
            })
        },
        switchTo(type) {
            this.$router.push({ name: 'Trends', params: { type }})
            this.loadTrends(type)
        }
    },
    mounted() {
        let type = this.$route.params.type || ""
        console.log(`trends ${type}`)
        if (_.includes(this.types, type)) {
            this.loadTrends(type)
        } else if (type === '') {
            this.switchTo("newest")
        } else {
            this.$router.push({ name: 'PageNotFound' })
        }
    }
}
</script>

<style lang="less" scoped>
@import "../css/_utils.less";
@import "../css/_flex_helper.less";
@import "../css/_palatte.less";

.trends {
    .flex-column;
    align-items: center;
    width: 112.0rem;

    .buttons {
        button {
            width: 20rem;
            margin: 0 0.3rem;
        }
    }

    .default-message {
        .flex-row;
        justify-content: center;
        margin-top: 4rem;
    }
}

.trends-grid {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    margin: 0 auto;
    margin-top: 1.5rem;
    margin-bottom: 2rem;

    .meme {
        margin: 1.5rem;

        .image {
            .square(30rem);
            border: 1px solid @palatte-border;
            border-radius: 0.8rem;
        }

        .user-info {
            margin-top: 1rem;

            .right {
                margin-left: 0.7rem;
            }

            .icon {
                .square(6rem);
                border: 1px solid @palatte-border;
                border-radius: 0.6rem;
            }

            .title {
                font-size: 2rem;
                font-weight: bold;
                color: @palatte-primary;
            }

            .title:hover {
                text-decoration: underline;
            }

            .info-bar {
                font-size: 1.5rem;
            }
        }
    }
}
</style>
