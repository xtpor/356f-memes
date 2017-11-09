<template>
    <div class="page">
        <title-box class="title-box"></title-box>
        <div class="pane-title">Reset Password Success</div>
        <div class="pane">
            <div class="pane-item" style="text-align: center">
                An email containing your new password has been sent.
                Please check your inbox.
            </div>
            <router-link :to="{name: 'Index'}">
                <button class="button pane-item">
                Back to Homepage
                </button>
            </router-link>
        </div>
    </div>
</template>

<script>
import TitleBox from './widgets/TitleBox'
import rpc from '../rpc'

export default {
    components: { TitleBox },
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
}
</style>
