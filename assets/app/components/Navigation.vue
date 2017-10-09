<template>
    <div class="header">
        <div style="display: flex">
            <div class="heading">
                <router-link class="title" :to="{ name: 'Index' }">
                    {{ meta.title }}
                </router-link>
                <span>{{ meta.subtitle }}</span>
            </div>
            <nav id="nav">
                <router-link class="item"
                             v-for="item in items"
                             :to="{ name: item }">
                    {{ item }}
                </router-link>
            </nav>
        </div>
        <div>
            <router-link class="button"
                         :to="{ name: 'SignIn' }">
                Sign-in
            </router-link>
            <router-link class="button button-outline"
                         :to="{ name: 'SignUp' }">
                Sign-Up
            </router-link>
        </div>
    </div>
</template>

<script>
import meta from '../meta'

export default {
    data () {
        return {
            meta,
            items: ['Generator', 'Trending', 'Random', 'Search']
        }
    }
}
</script>

<style scoped>
.header {
    height: 10rem;
    border-bottom: 1px solid #e4e1e1;
    margin: 0 auto;
    max-width: 112.0rem;
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.button {
    margin-bottom: 0px;
}

.heading {
    display: flex;
    flex-direction: column;
}

.title {
    color: #606c76;
    font-weight: bold;
    font-size: 2.5rem;
}

.title:hover {
    text-decoration: underline;
}

#nav {
    display: flex;
    align-items: center;
}

.item {
    text-decoration: none;
    color: #606c76;
    font-size: 1.8rem;
    margin-left: 5rem;
}

.item:hover {
    color: #9b4dca;
    text-decoration: underline;
}

</style>
