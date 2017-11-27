<template lang="html">
    <layout>
        <navigation slot="header"></navigation>
        <div class="form-container">
            <div class="submit-form">
                <h1>Help</h1>
                <p>
                    Need help with us?
                </p>
                <span>Name</span>
                <input type="text" v-model="name" />
                <span>Email</span>
                <input type="text" v-model="email"/>
                <span>Subject</span>
                <input type="text" v-model="subject"/>
                <span>How can we help?</span>
                <textarea v-model="content" placeholder="Please describe exactly what you’re trying to accomplish." />
                <button class="button" @click="submit">Submit</button>
                <div class="message" v-if="message">{{ message }}</div>
            </div>
        </div>
        <app-footer slot="footer"></app-footer>
    </layout>
</template>

<script>
import rpc from '../rpc'

import Layout from './Layout'
import Navigation from './Navigation'
import AppFooter from './Footer'

export default {
    components: { Layout, Navigation, AppFooter },
    data() {
        return { name: "", email: "", subject: "", content: "", message: "" }
    },
    methods: {
        submit() {
            rpc.call("/rpc/admin", "submit_help", this.name, this.email, this.subject, this.content)
                .then(resp => {
                    if (resp.status === "ok") {
                        this.name = this.email = this.subject = this.content =
                            this.message = ""
                        this.message = "Successfully submited"
                    }
                })
        }
    }
}
</script>

<style lang="less" scoped>
@import "../css/_flex_helper.less";
@import "../css/_palatte.less";

.form-container {
    display: flex;
    width: 112.0rem;
    flex-direction: column;
    align-items: center;

    .submit-form {
        width: 65rem;
    }
}

.message {
    color: @palatte-success;
}
</style>
