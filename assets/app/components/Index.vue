<template>
    <layout>
        <navigation slot="header"></navigation>
        <app-footer slot="footer"></app-footer>
    </layout>
</template>

<script>
  import _ from 'lodash'
  import Layout from './Layout'
  import Navigation from './Navigation'
  import AppFooter from './Footer'
  import StepIndicator from './widgets/StepIndicator'

  export default {
    components: { Layout, Navigation, AppFooter, StepIndicator },
    name: 'hello',
    data() {
      return {
        msg: 'Welcome to Your Vue.js App, bundled with Brunch!'
      }
    },
    methods: {
        basicSum (array) {
            return _.sum(array)
        }
    },
  }

</script>

<style>
</style>
