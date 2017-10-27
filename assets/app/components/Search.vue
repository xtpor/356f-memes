<template lang="html">
    <Layout>
        <navigation slot="header" search-bar="hide"></navigation>
        <div class="searching">
            <div class="option-row">
                <span class="row-header">
                        {{ advanced ? "Advanced Search" : "Search" }}
                </span>
                <div class="fx-row">
                    <input class="search-bar" type="search"
                        v-model="keywords" @keydown.enter="performSearch">
                    <button type="button" class="button" @click="performSearch">
                        Search
                    </button>
                </div>
            </div>
            <div class="option-row">
                <span class="row-header">Looking For</span>
                <div>
                <button :class="{'button-outline': mode !== 'user'}"
                    class="button" @click="mode = 'user'">
                    User</button>
                <button :class="{'button-outline': mode !== 'meme'}"
                    class="button" @click="mode = 'meme'">
                    Meme</button>
                </div>
            </div>
            <div class="option-row">
                <div v-if="advanced" class="option-row">
                    <span class="row-header" style="font-weight: bold">Advance Options</span>
                </div>
                <div v-else class="row-header"></div>
                <div>
                    <button type="button" class="button"
                        :class="{'button-outline': !advanced}"
                        @click="advanced = !advanced">
                        advanced
                    </button>
                </div>
            </div>
            <template v-if="advanced && mode === 'user'">
                <div class="option-row">
                    <span class="row-header"></span>
                    <span class="title">No Option</span>
                </div>
            </template>
            <template v-if="advanced && mode === 'meme'">
                <div class="option-row">
                    <span class="row-header">Created Before</span>
                    <input class="text-input" type="text"
                        placeholder="YYYY-MM-DD" v-model="createdBefore"/>
                </div>
                <div class="option-row">
                    <span class="row-header">Created After</span>
                    <input class="text-input" type="text"
                        placeholder="YYYY-MM-DD" v-model="createdAfter"/>
                </div>
                <div class="option-row">
                    <span class="row-header">Created By</span>
                    <input class="text-input" type="text"
                        placeholder="e.g. foo, bar, baz" v-model="createdBy"/>
                </div>
            </template>
            <hr />
            <template v-if="searchResult && resultType === 'user'">
                <div v-if="searchResult.length === 0" class="not-found">
                    No user found
                </div>
                <div class="user-container">
                    <router-link :to="{ name: 'User', params: { id: user.username} }"
                        class="result-user" v-for="user in searchResult">
                        <img class="icon" :src="imageURL(user.icon)"/>
                        <div class="name">{{ user.username }}</div>
                    </router-link>
                </div>
            </template>
            <template v-if="searchResult && resultType === 'meme'">
                <div v-if="searchResult.length === 0" class="not-found">
                    No meme found
                </div>
                <div class="meme-container">
                    <div class="result-meme fx-row" v-for="meme in searchResult">
                        <router-link :to="{ name: 'Meme', params: { id: meme.id } }">
                            <img class="meme-image" :src="imageURL(meme.image)"></img>
                        </router-link>
                        <div class="right-pane">
                            <router-link class="meme-title"
                                :to="{ name: 'Meme', params: { id: meme.id } }">
                                {{ meme.title || 'Untitled' }}
                            </router-link>
                            <div>
                                <i class="fa fa-user-o" aria-hidden="true"></i>
                                <router-link v-if="meme.username"
                                    :to="{ name: 'User', params: { id: meme.username } }">
                                    {{ meme.username}}
                                </router-link>
                                <span v-else>guest</span>
                            </div>
                            <div>
                                <i class="fa fa-calendar" aria-hidden="true"></i>
                                {{ formatDate(meme.created_at + 'Z') }}
                            </div>
                        </div>
                    </div>
                </div>
            </template>
        </div>
        <app-footer slot="footer"></app-footer>
    </Layout>
</template>

<script>
import { imageURL, formatDate } from '../utils'
import rpc from '../rpc'
import moment from 'moment'

import Layout from './Layout'
import Navigation from './Navigation'
import AppFooter from './Footer'

export default {
    components: { Layout, Navigation, AppFooter },
    data() {
        return {
            advanced: false,
            mode: "",
            keywords: "",
            createdBefore: "",
            createdAfter: "",
            createdBy: "",
            searchResult: null,
            resultType: "",
        }
    },
    methods: {
        imageURL, formatDate,
        readQueryString() {
            let q = this.$route.query
            this.advanced = q.cb || q.ca || q.u
            this.mode = q.m
            this.keywords = q.q || ''
            this.createdBefore = q.cb || ''
            this.createdAfter = q.ca || ''
            this.createdBy = q.u || ''
        },
        performSearch() {
            let query = {}
            if (this.mode === 'user') {
                let keywords = this.keywords.split(/\s+/)
                if (this.keywords !== '' && keywords.length > 0) {
                    rpc.call("/rpc/search", "search_user", keywords)
                        .then(({result}) => {
                            this.searchResult = result
                            this.resultType = 'user'
                        })
                    query.q = this.keywords
                } else {
                    this.searchResult = []
                    this.resultType = 'user'
                }
            } else if (this.mode === 'meme') {
                let opts = {}

                let keywords = this.keywords.split(/\s+/)
                if (this.keywords !== '' && keywords.length > 0) {
                    opts.keywords = keywords
                    query.q = this.keywords
                }

                if (this.createdBefore) {
                    opts.before = moment(this.createdBefore, "YYYY-MM-DD").toISOString()
                    query.cb = this.createdBefore
                }

                if (this.createdAfter) {
                    opts.after = moment(this.createdAfter, "YYYY-MM-DD").toISOString()
                    query.ca = this.createdAfter
                }

                if (this.createdBy) {
                    opts.created_by = this.createdBy
                    query.u = this.createdBy
                }

                rpc.call('rpc/search', 'search_meme', opts)
                    .then(({result}) => {
                        this.searchResult = result
                        this.resultType = 'meme'
                    })
            }
            query.m = this.mode
            this.$router.push({ name: 'Search', query })
        }
    },
    mounted() {
        this.readQueryString()
        if (this.mode) {
            this.performSearch()
        } else {
            this.mode = 'user'
        }
    }
}
</script>

<style lang="less">
@import "../css/_flex_helper.less";
@import "../css/_palatte.less";
@import "../css/_utils.less";

.searching {
    width: 112rem;

    .option-row {
        .flex-row;
        align-items: center;
        margin-top: 1rem;

        .row-header {
            width: 30rem;
            font-size: 2rem;
        }

        .title {
            font-size: 2rem;
        }

        button {
            margin-bottom: 0;
        }
    }

    .search-bar {
        width: 50rem;
        margin-right: 1.5rem;
    }

    .text-input {
        width: 40rem;
    }

    .user-container {
        display: grid;
        grid-template-columns: repeat(3, 1fr);

        .result-user {
            .flex-row;
            align-items: center;
            margin-top: 1rem;

            .icon {
                .square(5rem);
            }

            .name {
                margin-left: 1rem;
                font-size: 2.3rem;
            }

        }
    }

    .meme-container {
        display: grid;
        grid-template-columns: repeat(3, 1fr);

        .result-meme {
            margin-bottom: 1rem;
            .meme-image {
                .square(14rem);
                border: 1px solid @palatte-border;
            }

            .right-pane {
                .flex-column;
                margin-left: 1.4rem;
            }

            .meme-title {
                color: @palatte-primary;
                font-size: 2.0rem;
                font-weight: bold;
            }

            .meme-title:hover {
                text-decoration: underline;
            }

            .meme-info {
                font-size: 1.8rem;
            }
        }
    }

    .not-found {
        font-size: 3rem;
    }
}
</style>
