import Vue from 'vue'
import Router from 'vue-router'

import Index from '../components/Index'
import SignUp from '../components/SignUp'
import SignIn from '../components/SignIn'
import Generator from '../components/Generator'
import User from '../components/User'

Vue.use(Router)

export default new Router({
    mode: 'history',
    routes: [
        { path: '/', name: 'Index', component: Index },
        { path: '/register', name: 'SignUp', component: SignUp },
        { path: '/login', name: 'SignIn', component: SignIn },
        { path: '/generator', name: 'Generator', component: Generator },
        { path: '/trending', name: 'Trending', },
        { path: '/random', name: 'Random', },
        { path: '/search', name: 'Search', },
        { path: '/privacy', name: 'Privacy', },
        { path: '/terms', name: 'Terms', },
        { path: '/contact', name: 'ContactUs', },
        { path: '/about', name: 'About', },
        { path: '/help', name: 'Help', },
        { path: '/password-reset', name: 'PasswordReset', },
        { path: '/u/:id', name: 'User', component: User },
    ]
})
