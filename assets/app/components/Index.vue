<template>
    <layout>
        <navigation slot="header"></navigation>
        <app-footer slot="footer"></app-footer>
    </layout>
</template>

<script>
import _ from 'lodash'
import Cropper from 'cropperjs'

import Layout from './Layout'
import Navigation from './Navigation'
import AppFooter from './Footer'

export default {
    components: { Layout, Navigation, AppFooter },
}
</script>
