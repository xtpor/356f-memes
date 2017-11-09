<template>
    <div class="page">
        <title-box class="title-box"></title-box>
        <div class="pane-title">Reset Password</div>
        <div class="pane">
            <div class="pane-item">
                <span>Username</span>
                <input type="text" v-model="username"/>
            </div>
            <div class="pane-item">
                <span>Email Address</span>
                <input type="text" v-model="email"/>
            </div>
            <div v-if="errorMessage !== ''" class="error-message">
                {{ errorMessage }}
            </div>
            <button class="button pane-item" @click="send">Reset Password</button>
        </div>
    </div>
</template>

<script>
import TitleBox from './widgets/TitleBox'
import rpc from '../rpc'

export default {
    components: { TitleBox },
    data() {
        return {
            username: "",
            email: "",
            errorMessage: ""
        }
    },
    methods: {
        send() {
            rpc.call("/rpc/account", "reset_password", this.username, this.email)
                .then(resp => {
                    if (resp.status === "ok") {
                        this.$router.push({name: 'ResetSuccess'})
                    } else {
                        this.errorMessage = resp.reason
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

    .error-message {
        margin-top: -1rem;
        margin-bottom: 0.5rem;
        color: rgb(227, 93, 89);
        text-align: center;
        font-size: 1.5rem;
    }
}
</style>
