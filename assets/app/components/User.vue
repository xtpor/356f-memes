<template lang="html">
    <layout>
        <navigation slot="header"></navigation>
        <div v-if="info">
            <div class="user">
                <div class="icon">
                    icon
                </div>
                <div class="user-info">
                    <div class="name-row">
                        <span class="user-name">{{ info.name }}</span>
                        <span class="user-username">(@{{ info.username }})</span>
                    </div>
                    <div class="user-bio">
                        {{ info.bio }}
                    </div>
                </div>
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

export default {
    components: { Layout, Navigation, AppFooter },
    data() {
        return {info: null}
    },
    mounted() {
        let user = this.$route.params.id
        rpc.call("/rpc/account", "info", user)
            .then(resp => this.info = resp.result)
    }
}
</script>

<style lang="less" scoped>
.user {
    display: flex;
    width: 112.0rem;
    border-bottom: 1px solid black;
    padding-top: 1rem;

    .icon {
        margin-left: 0.3rem;
        margin-bottom: 0.5rem;
        width: 10rem;
        height: 10rem;
        border: 1px solid black;
        border-radius: 0.3rem;
    }

    .user-info {
        margin-left: 1rem;

        .name-row {
            .user-name {
                font-size: 2.7rem;
            }
            .user-username {
                font-size: 2.2rem;
            }
            margin-bottom: 0.8rem;
        }

        .user-bio {
            width: 35rem;
            max-height: 8rem;
            margin-bottom: 0.5rem;
        }
    }
}
</style>
