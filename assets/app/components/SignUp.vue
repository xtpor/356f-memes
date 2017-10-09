<template lang="html">
    <div class="signup">
        <title-box class="title-box"></title-box>
        <div class="pane-title">Sign Up</div>
        <div class="pane">
            <div class="pane-item">
                Username
                <input type="text" name="" value="">
            </div>
            <div class="pane-item">
                Email Address
                <input type="text" name="" value="">
            </div>
            <div class="pane-item">
                Password
                <input type="text" name="" value="">
            </div>
            <button class="button pane-item">Create an account</button>
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
import TitleBox from './widgets/TitleBox'

export default {
    components: { TitleBox }
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
}
</style>
