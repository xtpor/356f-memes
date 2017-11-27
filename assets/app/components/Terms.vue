<template lang="html">
    <layout>
        <navigation slot="header"/>
        <div class="frame">
            <div class="content">
                <h1 id="terms-of-use">Terms of Use</h1>
                <h2 id="basic-terms">Basic Terms</h2>
                <ol style="list-style-type: decimal">
                <li>You must be at least 16 years old to use the Service.</li>
                <li>You may not post violent, nude, partially nude, discriminatory, unlawful, infringing, hateful, pornographic or sexually suggestive photos or other content via the Service.</li>
                <li>You are responsible for any activity that occurs through your account and you agree you will not sell, transfer, license or assign your account, followers, username, or any account rights. With the exception of people or businesses that are expressly authorized to create accounts on behalf of their employers or clients, Monkey’s Dictionary prohibits the creation of and you agree that you will not create an account for anyone other than yourself. You also represent that all information you provide or provided to Monkey’s Dictionary upon registration and at all other times will be true, accurate, current and complete and you agree to update your information as necessary to maintain its truth and accuracy.</li>
                <li>You agree that you will not solicit, collect or use the login credentials of other Monkey’s Dictionary users.</li>
                <li>You are responsible for keeping your password secret and secure.</li>
                <li>You must not defame, stalk, bully, abuse, harass, threaten, impersonate or intimidate people or entities and you must not post private or confidential information via the Service, including, without limitation, your or any other person's credit card information, social security or alternate national identity numbers, non-public phone numbers or non-public email addresses.</li>
                <li>You may not use the Service for any illegal or unauthorized purpose. You agree to comply with all laws, rules and regulations (for example, federal, state, local and provincial) applicable to your use of the Service and your Content (defined below), including but not limited to, copyright laws.</li>
                <li>You are solely responsible for your conduct and any data, text, files, information, usernames, images, graphics, photos, profiles, works of authorship, applications, links and other content or materials (collectively, &quot;Content&quot;) that you submit, post or display on or via the Service.</li>
                <li>You must not change, modify, adapt or alter the Service or change, modify or alter another website so as to falsely imply that it is associated with the Service or Monkey’s Dictionary.</li>
                <li>You must not access Monkey’s Dictionary's private API by means other than those permitted by Monkey’s Dictionary. Use of Monkey’s Dictionary's API is subject to a separate set of terms available here (&quot;API Terms&quot;).</li>
                <li>You must not create or submit unwanted email, comments, likes or other forms of commercial or harassing communications (a/k/a &quot;spam&quot;) to any Monkey’s Dictionary users.</li>
                <li>You must not use domain names or web URLs in your username without prior written consent from Monkey’s Dictionary.</li>
                <li>You must not interfere or disrupt the Service or servers or networks connected to the Service, including by transmitting any worms, viruses, spyware, malware or any other code of a destructive or disruptive nature. You may not inject content or code or otherwise alter or interfere with the way any Monkey’s Dictionary page is rendered or displayed in a user's browser or device.</li>
                <li>You must comply with Monkey’s Dictionary's Community Guidelines.</li>
                <li>You must not create accounts with the Service through unauthorized means, including but not limited to, by using an automated device, script, bot, spider, crawler or scraper.</li>
                <li>You must not attempt to restrict another user from using or enjoying the Service and you must not encourage or facilitate violations of these Terms of Use or any other Monkey’s Dictionary terms.</li>
                <li>Violation of these Terms of Use may, in Monkey’s Dictionary's sole discretion, result in termination of your Monkey’s Dictionary account. You understand and agree that Monkey’s Dictionary cannot and will not be responsible for the Content posted on the Service and you use the Service at your own risk. If you violate the letter or spirit of these Terms of Use, or otherwise create risk or possible legal exposure for Monkey’s Dictionary, we can stop providing all or part of the Service to you.</li>
                </ol>
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
