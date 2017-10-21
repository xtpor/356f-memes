<template lang="html">
    <div class="signup">
        <title-box class="title-box"></title-box>
        <div class="pane-title">Sign Up</div>
        <div class="pane">
            <div class="pane-item">
                Username
                <input type="text" name="username" v-model="username"/>
            </div>
            <div class="pane-item">
                Password
                <input type="password" v-model="password"/>
            </div>
            <div class="pane-item">
                Email Address
                <input type="email" v-model="email"/>
            </div>
            <div v-if="errorMessage !== ''" class="error-message">{{ errorMessage }}</div>
            <button class="button pane-item" @click="register">
                Create an account
            </button>
        </div>
        <div class="pane-outline">
            By signing up you agree to our
            <router-link :to="{ name: 'Terms' }">Terms of Service</router-link>
            and
            <router-link :to="{ name: 'Privacy' }">Privacy Policy</router-link>.
        </div>
    </div>
</template>

<script>
import rpc from '../rpc'
import TitleBox from './widgets/TitleBox'

export default {
    components: { TitleBox },
    data() {
        return {
            username: "",
            password: "",
            email: "",
            errorMessage: "",
        }
    },
    methods: {
        register() {
            rpc.call("/rpc/account", "register", this.username, this.password, this.email)
                .then(result => {
                    if (result.status === "ok") {
                        console.log("registration ok")
                        this.$router.push({name: 'Index'})
                    } else if (result.status == "error") {
                        console.log("registration error")
                        this.errorMessage = result.reason
                    }
                })
        }
    },
}
</script>

<style lang="less" scoped>
@import "../css/_pane.less";

.signup {
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
        font-size: 1.3rem;
        margin-top: 1rem;
    }

    .error-message {
        margin-top: -0.5rem;
        margin-bottom: 0.5rem;
        color: rgb(227, 93, 89);
    }
}
</style>
