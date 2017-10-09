import Vue from 'vue'
import App from './App'
import router from './router'
import "vueify/lib/insert-css" // required for .vue file <style> tags

/*
Unless a npm module was already imported in a js file, importing the
npm module from .vue files will not work, see
https://github.com/theocodes/vue-brunch/issues/6 for more details.
*/
import _ from 'lodash'
import axios from 'axios'

Vue.config.productionTip = false

/* eslint-disable no-new */
new Vue({
    el: '#app',
    router,
    render: h => h(App)
})
