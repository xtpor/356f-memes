<template lang="html">
    <div class="footer">
        <span class="copyright">&copy; {{ year() }} {{ meta.title }} </span>
        <router-link class="item" v-for="item in items" :to="{ name: item.name }">
            {{ item.text }}
        </router-link>
    </div>
</template>

<script>
import meta from '../meta';

export default {
    data () {
        return {
            meta,
            items: [
                {text: 'Privacy', name: 'Privacy'},
                {text: 'Terms of Use', name: 'Terms'},
                {text: 'Report Content', name: 'ReportContent'},
                {text: 'Help', name: 'Help'},
                {text: 'Search', name: 'Search'},
            ]
        }
    },
    methods: {
        year: () =>(new Date()).getFullYear()
    }
}
</script>

<style scoped>
.footer {
    height: 5rem;
    max-width: 112.0rem;
    border-top: 1px solid #e4e1e1;
    margin: 0 auto;
    display: flex;
    align-items: center;
    font-size: 1.4rem;
}

.copyright {
    margin-right: 2rem;
}

.item {
    margin-left: 3rem;
}
</style>
