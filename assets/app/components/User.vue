<template lang="html">
    <layout>
        <navigation slot="header" @logout="updateEditable"></navigation>
        <div v-if="info">
            <div class="user">
                <img class="icon" :src="iconURL">
                </img>
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
        </div>
        <app-footer slot="footer"></app-footer>
    </layout>
</template>

<script>
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
            iconURL: null,
        }
    },
    methods: {
        updateEditable() {
            let user = this.$route.params.id
            console.log("updateEditable")
            let as = account.loginAs()
            this.editable = as && as.username === user
        }
    },
    mounted() {
        let user = this.$route.params.id
        rpc.call("/rpc/account", "info", user)
            .then(resp => {
                this.info = resp.result
                this.info.username = user
                this.iconURL = this.info.icon ?
                    `/archive/${this.info.icon}` : '/images/default-icon.svg'
                console.log(this.iconURL)
            })
        this.updateEditable()
    }
}
</script>

<style lang="less" scoped>
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
</style>
