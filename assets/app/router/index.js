import Vue from 'vue'
import Router from 'vue-router'

import SignUp from '../components/SignUp'
import SignIn from '../components/SignIn'
import Generator from '../components/Generator'
import User from '../components/User'
import Profile from '../components/Profile'
import Meme from '../components/Meme'
import Trends from '../components/Trends'
import Search from '../components/Search'
import PageNotFound from '../components/PageNotFound'
import PasswordReset from '../components/PasswordReset'
import ResetSuccess from '../components/ResetSuccess'
import Help from '../components/Help'
import ReportContent from '../components/ReportContent'
import AdminConsole from '../components/AdminConsole'
import Privacy from '../components/Privacy'
import Terms from '../components/Terms'

Vue.use(Router)

export default new Router({
    mode: 'history',
    routes: [
        { path: '/', name: 'Index', redirect: { name: 'Generator' } },
        { path: '/register', name: 'SignUp', component: SignUp },
        { path: '/login', name: 'SignIn', component: SignIn },
        { path: '/generator', name: 'Generator', component: Generator },
        { path: '/trends/:type', name: 'Trends', component: Trends },
        { path: '/search', name: 'Search', component: Search },
        { path: '/privacy', name: 'Privacy', component: Privacy },
        { path: '/terms', name: 'Terms', component: Terms },
        { path: '/report-content', name: 'ReportContent', component: ReportContent },
        { path: '/admin', name: 'AdminConsole', component: AdminConsole },
        { path: '/help', name: 'Help', component: Help },
        { path: '/password-reset', name: 'PasswordReset', component: PasswordReset },
        { path: '/reset-success', name: 'ResetSuccess', component: ResetSuccess },
        { path: '/u/:id', name: 'User', component: User },
        { path: '/m/:id', name: 'Meme', component: Meme },
        { path: '/profile', name: 'Profile', component: Profile },
        { path: '*', redirect: { name: 'PageNotFound' } },
        { path: '/404', name: 'PageNotFound', component: PageNotFound },
    ]
})
