<template>
    <div class="page">
        <title-box class="title-box"></title-box>
        <div class="pane-title">Sign In</div>
        <div class="pane">
            <div class="pane-item">
                <span>Username</span>
                <input type="text" name="" value="">
            </div>
            <div class="pane-item">
                <div class="two-end">
                    <span>Password</span>
                    <router-link :to="{ name: 'PasswordReset' }"
                    >Forgot password?</router-link>
                </div>
                <input type="password" name="" value="">
            </div>
            <button class="button pane-item">Log in</button>
        </div>

        <div class="pane-outline">
            Don't have an account?
            <router-link :to="{ name: 'SignUp' }">Create one.</router-link>
        </div>
    </div>
</template>

<script>
import TitleBox from './widgets/TitleBox'

export default {
    components: { TitleBox }
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
}

.two-end {
    display: flex;
    justify-content: space-between;
}
</style>
