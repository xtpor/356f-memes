<template>
    <div class="page">
        <title-box class="title-box"></title-box>
        <div class="pane-title">Sign In</div>
        <div class="pane">
            <div class="pane-item">
                <span>Username</span>
                <input type="text" v-model="username"/>
            </div>
            <div class="pane-item">
                <div class="two-end">
                    <span>Password</span>
                    <router-link :to="{ name: 'PasswordReset' }"
                    >Forgot password?</router-link>
                </div>
                <input type="password" v-model="password"/>
            </div>
            <div class="pane-item">
                <label>
                    <input type="checkbox" v-model="rememberMe"/>
                    <span class="remember-me">Remember me</span>
                </label>
            </div>
            <div v-if="errorMessage !== ''" class="error-message">
                {{ errorMessage }}
            </div>
            <button class="button pane-item" @click="login">Log in</button>
        </div>

        <div class="pane-outline">
            Don't have an account?
            <router-link :to="{ name: 'SignUp' }">Create one.</router-link>
        </div>
    </div>
</template>

<script>
import TitleBox from './widgets/TitleBox'
import account from '../account'

export default {
    components: { TitleBox },
    data() {
        return {
            username: "",
            password: "",
            rememberMe: false,
            errorMessage: "",
            timeoutId: 0,
        }
    },
    methods: {
        login() {
            window.clearTimeout(this.timeoutId)
            account.login(this.username, this.password, this.rememberMe)
                .then(resp => {
                    if (resp.status === 'ok') {
                        this.$router.push({name: 'Index'})
                    } else if (resp.status == 'error') {
                        this.errorMessage = resp.reason
                        this.timeoutId = setTimeout(() => {
                            this.errorMessage = ""
                        }, 3000)
                    }
                })
        }
    }
}
</script>

<style lang="less" scoped>
@import "../css/_pane.less";

.page {
    background-color: #fdfafe;
    display: flex;
    flex-direction: column;
    align-items: center;
    min-height: 100vh;
    font-size: 1.4rem;

    .title-box {
        padding-top: 2.8rem;
    }

    .pane-title {
        margin-top: 2.0rem;
    }

    .pane {
        margin-top: 2rem;

        button {
            width: 100%;
            margin-bottom: 0;
        }
    }

    .pane-outline {
        margin-top: 1rem;
        text-align: center;
    }

    .error-message {
        margin-top: -1rem;
        margin-bottom: 0.5rem;
        color: rgb(227, 93, 89);
        text-align: center;
        font-size: 1.5rem;
    }

    .remember-me {
        font-weight: normal;
        font-size: 1.4rem;
    }
}

.two-end {
    display: flex;
    justify-content: space-between;
}
</style>
