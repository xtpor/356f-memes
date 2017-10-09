<template lang="html">
    <div class="step-indicator">
        <div class="inactive">
            <span class="step">1</span>
            <span class="text">text1</span>
        </div>
        <div class="inactive">
            <span class="step">2</span>
            <span class="text">text2</span>
        </div>
        <div class="active">
            <span class="step">3</span>
            <span class="text">text3</span>
        </div>
        <div class="inactive">
            <span class="step">4</span>
            <span class="text">text4</span>
        </div>
    </div>
</template>

<script>
export default {
}
</script>

<style lang="less" scoped>
@import "../../css/_palatte.less";

.step-indicator {
    display: flex;

    .active, .inactive {
        display: flex;
        align-items: center;
        margin-right: 0.5rem;

        .step {
            display: flex;
            justify-content: center;
            align-items: center;

            width: 3rem;
            height: 3rem;
            border-radius: 0.4rem;
            border: 1px solid @palatte-secondary;
            font-weight: bold;
        }

        .text {
            margin-left: 0.8rem;
            font-size: 2rem;
            border-bottom: 1px solid @palatte-secondary;
        }
    }

    .active {
        .step {
            background-color: @palatte-secondary;
            color: white;
        }

        .text {
            display: inline;
        }
    }

    .inactive {
        .step {
            background-color: white;
            color: @palatte-secondary;
        }

        .text {
            display: none;
        }
    }
}
</style>
