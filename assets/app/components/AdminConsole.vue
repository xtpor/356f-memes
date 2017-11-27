<template lang="html">
    <div class="admin-console">
        <h1>Admin console</h1>
        <router-link :to="{ name: 'Index' }">back to homepage</router-link>
        <div class="panel-item">
            <h2>Reply to inappropriate content reports</h2>
            <div>There are {{ reports.length }} reports.</div>
            <template v-if="reports.length > 0">
                <h3>Report ( {{ reportPtr + 1 }} / {{ reports.length }} )</h3>
                <div>Name: {{ currentReport.name }}</div>
                <div>Email: {{ currentReport.email }}</div>
                <div>Subject: {{ currentReport.subject }}</div>
                <pre>{{ currentReport.content }} </pre>
                <div>Your reply</div>
                <textarea v-model="reportReply"></textarea>
                <button class="button" @click="prevReport">prev</button>
                <button class="button button-outline" @click="deleteReport">delete</button>
                <button class="button" @click="replyReport">reply</button>
                <button class="button button-outline" @click="nextReport">next</button>
            </template>
            <div v-else>No report to show</div>
        </div>
        <div class="panel-item">
            <h2>Answer user's request for help</h2>
            <div>There are {{ helps.length }} helps.</div>
            <template v-if="helps.length > 0">
                <h3>help ( {{ helpPtr + 1 }} / {{ helps.length }} )</h3>
                <div>Name: {{ currentHelp.name }}</div>
                <div>Email: {{ currentHelp.email }}</div>
                <div>Subject: {{ currentHelp.subject }}</div>
                <pre>{{ currentHelp.content }} </pre>
                <div>Your reply</div>
                <textarea v-model="helpReply"></textarea>
                <button class="button" @click="prevHelp">prev</button>
                <button class="button button-outline" @click="deleteHelp">delete</button>
                <button class="button" @click="replyHelp">reply</button>
                <button class="button button-outline" @click="nextHelp">next</button>
            </template>
            <div v-else>No help to show</div>
        </div>
    </div>
</template>

<script>
import rpc from "../rpc"
import account from "../account"

export default {
    data() {
        return {
            helps: [],
            helpPtr: 0,
            helpReply: "",
            reports: [],
            reportPtr: 0,
            reportReply: "",
        }
    },
    computed: {
        currentReport() {
            return this.reports[this.reportPtr]
        },
        currentHelp() {
            return this.helps[this.helpPtr]
        }
    },
    mounted() {
        rpc.call("/rpc/admin", "fetch_helps", account.token())
            .then(resp => {
                this.helps = resp.result
            })

        rpc.call("/rpc/admin", "fetch_reports", account.token())
            .then(resp => {
                this.reports = resp.result
            })
    },
    methods: {
        prevReport() {
            this.reportPtr = Math.max(this.reportPtr - 1, 0)
        },
        nextReport() {
            this.reportPtr = Math.min(this.reportPtr + 1, this.reports.length - 1)
        },
        deleteReport() {
            rpc.call("/rpc/admin", "delete_report", account.token(), this.currentReport.id)
                .then(resp => {
                    return rpc.call("/rpc/admin", "fetch_reports", account.token())
                })
                .then(resp => {
                    this.reports = resp.result
                    alert("deleted");
                })
        },
        replyReport() {
            let subject = "Reply to your report of inappropriate content of Monkey's Dictionary"
            rpc.call("/rpc/admin", "send_email", account.token(),
                this.currentReport.email, subject, this.reportReply)
                .then(resp => {
                    alert("replied");
                })
        },
        prevHelp() {
            this.helpPtr = Math.max(this.helpPtr - 1, 0)
        },
        nextHelp() {
            this.helpPtr = Math.min(this.helpPtr + 1, this.helps.length - 1)
        },
        deleteHelp() {
            rpc.call("/rpc/admin", "delete_help", account.token(), this.currentHelp.id)
                .then(resp => {
                    return rpc.call("/rpc/admin", "fetch_helps", account.token())
                })
                .then(resp => {
                    this.helps = resp.result
                    alert("deleted");
                })
        },
        replyHelp() {
            let subject = "Reply to your request for help in Monkey's Dictionary"
            rpc.call("/rpc/admin", "send_email", account.token(),
                this.currentHelp.email, subject, this.helpReply)
                .then(resp => {
                    alert("replied");
                })
        },
    }
}
</script>

<style lang="less" scoped>
.admin-console {
    margin-left: 2rem;
}

.panel-item {
    width: 60rem;

    button {
        margin-top: 1rem;
    }
}
</style>
