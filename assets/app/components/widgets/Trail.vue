<template lang="html">
    <div class="trail">
        <button class="button button-outline" @click="$emit('back')">back</button>
        <div class="list">
            {{ first }}
            <template v-for="item in rest">
                <span class="seperator"> > </span>
                {{ item }}
            </template>
        </div>
    </div>
</template>

<script>
export default {
    props: ["items"],
    computed: {
        first() {
            return this.items[0]
        },
        rest() {
            return this.items.slice(1)
        }
    }
}
</script>

<style lang="less" scoped>
@import "../../css/_flex_helper.less";

.trail {
    .flex-row;

    button {
        margin-bottom: 0;
    }

    .list {
        margin-left: 1rem;
        font-size: 2.0rem;

        .seperator {
            font-size: 2.5rem;
        }
    }
}

</style>
