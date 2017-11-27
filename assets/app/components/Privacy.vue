<template lang="html">
    <layout>
        <navigation slot="header"/>
        <div class="frame">
            <div class="content">
                <h1 id="privacy-policy">Privacy Policy</h1>
                <p>Monkey’s Dictionary is concerned to ensure that all personal data submitted through this website are handled in strict adherence to the relevant provisions of the Personal Data (Privacy) Ordinance (PD(P)O).</p>
                <h2 id="collection-of-information">Collection of Information</h2>
                <p>Our administrators will record the visits to Monkey’s Dictionary by using cookies and page tagging without collecting any personal identifiable information of users.</p>
                <h3 id="session-storage">Session storage</h3>
                <p>Session storage is a small amount of data created in a computer when a person visits a website on the computer. It often includes an anonymous unique identifier. A session storage can be used to identify a computer, but it is not used to collect any personal information. In other words, it does not have the function of identifying an individual user of the website.</p>
                <p>You may choose to accept or reject session storage. If you reject it, you will not be able to keep the login state of Monkey’s Dictionary.</p>
                <h2 id="provision-of-personal-data">Provision of Personal Data</h2>
                <p>For different purposes and at different times you may be invited to provide personal data to Monkey’s Dictionary on a voluntary basis. Personal information may include name or e-mail address. Monkey’s Dictionary will specify the collection purpose and intended usage of your data when it invites you to provide such information and advise you how you may request access to or correction of the personal data provided.</p>
                <p>Unless permitted or required by law, Monkey’s Dictionary will not disclose your personal data to any third parties without your prior consent.</p>
                <p>Monkey’s Dictionary would protect your personal data. All personal data you provide to Monkey’s Dictionary are secured, and access to them is restricted to authorised personnel only.</p>
                <h2 id="search-service">Search Service</h2>
                <p>Search service on Monkey’s Dictionary is based on the user’s inputted keywords. According on their similarities, corresponding results will be displayed. It does not collect personal identifiable information while serving search results through Monkey’s Dictionary. Anonymous data may be collected through the search service with Monkey’s Dictionary for compiling traffic analysis on the website.</p>
            </div>
        </div>
        <app-footer slot="footer" />
    </layout>
</template>

<script>
import Layout from './Layout'
import Navigation from './Navigation'
import AppFooter from './Footer'

export default {
    components: {Layout, Navigation, AppFooter}
}
</script>

<style lang="less" scoped>
.frame {
    width: 112.0rem;
    display: flex;
    justify-content: center;
}

.content {
    width: 70rem;
}
</style>
