<template lang="html">
    <layout>
        <navigation slot="header"></navigation>
        <div class="trends">
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
                        <div class="username">
                            by
                            <router-link v-if="meme.username"
                                :to="{ name: 'User', params: { id: meme.username} }">
                                {{ meme.username }}
                            </router-link>
                            <span v-else>a guest</span>
                            <i class="fa fa-clock-o" aria-hidden="true"></i>
                            {{ formatFromNow(meme.created_at + 'Z') }}
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <app-footer slot="footer"></app-footer>
    </layout>
</template>

<script>
import { imageURL, formatFromNow } from '../utils'
import rpc from '../rpc'

import Layout from './Layout'
import Navigation from './Navigation'
import AppFooter from './Footer.vue'

export default {
    components: { Layout, Navigation, AppFooter },
    data() {
        return {
            memes: []
        }
    },
    methods: {
        imageURL, formatFromNow
    },
    mounted() {
        rpc.call("/rpc/meme", "trends").then(({result: memes}) => {
            this.memes = memes
        })
    }
}
</script>

<style lang="less" scoped>
@import "../css/_utils.less";
@import "../css/_flex_helper.less";
@import "../css/_palatte.less";

.trends {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    margin: 0 auto;
    margin-top: 1.5rem;

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
                margin-left: 1rem;
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

            .username {
            }
        }
    }
}
</style>
