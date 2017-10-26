<template>
    <header class="header">
        <div style="display: flex">
            <div class="heading">
                <router-link class="title" :to="{ name: 'Index' }">
                    {{ meta.title }}
                </router-link>
                <span class="subtitle">{{ meta.subtitle }}</span>
            </div>
            <nav id="nav">
                <router-link class="item"
                             v-for="item in items"
                             :to="{ name: item }">
                    {{ item }}
                </router-link>
            </nav>
        </div>
        <div class="box-right">
            <template v-if="loginAs">
                <div class="login-as">
                    Welcome,
                    <router-link :to="destination()">
                        {{ loginAs.username }}
                    </router-link>
                </div>
                <button class="button logout" @click="logout">logout</button>
            </template>
            <template v-else>
                <router-link class="button"
                             :to="{ name: 'SignIn' }">
                    Sign-in
                </router-link>
                <router-link class="button button-outline"
                             :to="{ name: 'SignUp' }">
                    Sign-Up
                </router-link>
            </template>
        </div>
    </header>
</template>

<script>
import meta from '../meta'
import account from '../account'

export default {
    data() {
        return {
            meta,
            items: ['Generator', 'Trends', 'Search'],
            loginAs: null
        }
    },
    methods: {
        logout() {
            account.logout()
            this.loginAs = null
            this.$emit("logout")
        },
        destination() {
            let user = account.loginAs().username
            return { name: 'User', params: { id: user } }
        }
    },
    mounted() {
        this.loginAs = account.loginAs()
    }
}
</script>

<style lang="less" scoped>
@import "../css/_palatte.less";

.header {
    height: 10%;
    width: 112.0rem;

    border-bottom: 1px solid #e4e1e1;
    margin: 0 auto;
    padding-top: 0.5rem;
    padding-bottom: 0.2rem;
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.button {
    margin-bottom: 0px;
}

.heading {
    display: flex;
    flex-direction: column;
}

.title {
    // border: 1px solid black;
    color: @palatte-primary;
    font-weight: bold;
    font-size: 2.5rem;
}

.title:hover {
    text-decoration: underline;
}

.subtitle {
    margin-top: -1rem;
    font-size: 1.5rem;
    // border: 1px solid black;
}

#nav {
    display: flex;
    align-items: center;
}

.item {
    text-decoration: none;
    color: @palatte-primary;
    font-size: 1.8rem;
    margin-left: 5rem;
}

.item:hover {
    color: @palatte-secondary;
    text-decoration: underline;
}

.box-right {
    display: flex;
    align-items: center;

    .login-as {
        font-size: 1.7rem;
    }

    .logout {
        padding-left: 1rem;
        padding-right: 1rem;
        border-radius: 0.5rem;
    }
}

.box-right > * {
    margin-left: 1rem;
}

</style>
