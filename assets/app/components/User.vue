<template lang="html">
    <layout>
        <navigation slot="header" @logout="updateEditable"></navigation>
        <div v-if="info">
            <div class="user">
                <img v-if="info.icon" class="icon" :src="`/archive/${this.info.icon}`" />
                <img v-else class="icon" src="/images/default-icon.svg" />
                <div class="user-info">
                    <div class="top-row">
                        <div class="name-row">
                            <span class="user-name">{{ info.name }}</span>
                            <span class="user-username">(@{{ info.username }})</span>
                        </div>
                        <router-link v-if="editable" :to="{ name: 'Profile' }"
                                class="button button-outline edit-button">
                            <i class="fa fa-user" aria-hidden="true"></i>
                            <span>Edit</span>
                        </router-link>
                    </div>
                    <div class="user-bio">
                        <div v-for="line in info.bio.split('\n')">
                            {{ line }}
                        </div>
                    </div>
                </div>
            </div>
            <div class="memes-album">
                <div class="album-item" v-for="item in album">
                    <img class="icon" :src="`/archive/${item.image}`"></img>
                    <div class="right">
                        <span class="title">{{ item.title || "Untitled" }}</span>
                        <span class="rest">
                            <span class="info-item">
                                <i class="fa fa-globe" aria-hidden="true"></i>
                                <router-link :to="{ name: 'Meme', params: { id: item.id} }">
                                    {{ item.id }}
                                </router-link>
                            </span>
                            <span class="info-item">
                                <i class="fa fa-clock-o" aria-hidden="true"></i>
                                {{ formatFromNow(item.created_at) }}
                            </span>
                            <span class="info-item">
                                <i class="fa fa-calendar" aria-hidden="true"></i>
                                {{ formatDate(item.created_at) }}
                            </span>
                            <span class="info-item">
                                <i class="fa fa-thumbs-o-up" aria-hidden="true"></i>
                                {{ item.num_likes }}
                            </span>
                        </span>

                    </div>
                </div>
            </div>
            <div v-if="album.length === 0" class="no-meme">
                This user doesn't not have any meme to show
            </div>
        </div>
        <app-footer slot="footer"></app-footer>
    </layout>
</template>

<script>
import { formatFromNow, formatDate } from 'utils'
import rpc from '../rpc'
import account from '../account'

import Layout from './Layout'
import Navigation from './Navigation'
import AppFooter from './Footer'

export default {
    components: { Layout, Navigation, AppFooter },
    data() {
        return {
            info: {bio: ""},
            editable: false,
            album: [],
        }
    },
    methods: {
        formatFromNow,
        formatDate,
        updateEditable() {
            let user = this.$route.params.id
            console.log("updateEditable")
            let as = account.loginAs()
            this.editable = as && as.username === user
        },
    },
    mounted() {
        let user = this.$route.params.id
        rpc.call("/rpc/account", "info", user)
            .then(resp => {
                if (resp.status === "ok") {
                    this.info = resp.result
                    this.info.username = user
                    console.log(this.iconURL)

                    return rpc.call("/rpc/image", "user_album", user)
                } else {
                    this.$router.push({ name: "PageNotFound" })
                }
            })
            .then(resp => {
                if (resp.status === "ok") {
                    this.album = resp.result
                }
            })
        this.updateEditable()
    }
}
</script>

<style lang="less" scoped>
@import "../css/_flex_helper.less";
@import "../css/_palatte.less";

.user {
    display: flex;
    width: 112.0rem;
    border-bottom: 1px solid #e4e1e1;
    padding-top: 1rem;

    .icon {
        margin-left: 0.3rem;
        margin-bottom: 0.5rem;
        width: 10rem;
        height: 10rem;
        border-radius: 0.3rem;
    }

    .user-info {
        display: flex;
        flex-direction: column;
        flex-grow: 1;
        margin-left: 1rem;
        overflow: hidden;

        .top-row {
            display: flex;
            justify-content: space-between;
            align-items: center;

            .name-row {
                display: flex;
                align-items: center;

                .user-name {
                    font-size: 2.7rem;
                }
                .user-username {
                    margin-left: 1rem;
                    font-size: 2.2rem;
                }
                margin-bottom: 0.8rem;
            }

            .edit-button {
                font-size: 1.6rem;
                padding-right: 1.5rem;
                padding-left: 1.5rem;

                span {
                    font-size: 1.15rem;
                }
            }
        }

        .user-bio {
            width: 35rem;
            max-height: 11.5rem;
            margin-bottom: 1.5rem;
        }
    }
}

.memes-album {
    .flex-column;
    margin-left: 1rem;
    margin-bottom: 1rem;

    .album-item {
        .flex-row;
        align-items: flex-start;
        margin-top: 1rem;

        .icon {
            width: 6rem;
            height: 6rem;
        }

        .right {
            margin-left: 1rem;
            .flex-column;

            .title {
                font-weight: bold;
                font-size: 1.8rem;
            }

            .info-item {
                margin-right: 1.5rem;
            }
        }
    }
}

.no-meme {
    font-size: 2.3rem;
}
</style>
