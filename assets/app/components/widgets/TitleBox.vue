<template lang="html">
    <div class="title-box">
        <router-link :to="{ name: 'Index' }" class="title">{{ meta.title }}</router-link>
        <span class="subtitle">{{ meta.subtitle }}</span>
    </div>
</template>

<script>
import meta from '../../meta'

export default {
    data () {
        return { meta: meta }
    }
}
</script>

<style lang="less" scoped>
@import "../../css/_palatte.less";

.title-box {
    max-width: 30rem;
    display: flex;
    flex-direction: column;
    align-items: center;

    .title {
        color: @palatte-primary;
        font-weight: bold;
        font-size: 2.5rem;
    }

    .title:hover {
        text-decoration: underline;
    }

    .subtitle {
        font-size: 1.35rem
    }
}

</style>
