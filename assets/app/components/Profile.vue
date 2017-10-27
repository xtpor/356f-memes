<template lang="html">
    <layout>
        <navigation slot="header"></navigation>
        <div class="profile">
            <div class="profile-wrapper">
                <h1>My Profile</h1>
                <div class="profile-row">
                    <div>Username:</div>
                    <div>{{ username }}</div>
                </div>
                <div class="profile-row">
                    <div>Password:</div>
                    <div>
                        <input type="password" placeholder="Old password"
                            v-model="oldPassword">
                        <input type="password" placeholder="New password"
                            v-model="newPassword">
                        <span :class="[passwordStatus]">{{ passwordStatusText }}</span>
                    </div>
                </div>
                <div class="profile-row">
                    <div>Email Address:</div>
                    <div>
                        <input type="email" v-model="newEmail">
                        <span :class="[emailStatus]">{{ emailStatusText }}</span>
                    </div>
                </div>
                <div class="profile-row">
                    <div>Avatar:</div>
                    <div>
                        <img v-show="!newIcon && !iconURL"
                            src="/images/default-icon.svg"
                            class="profile-icon"></img>
                        <img v-show="!newIcon && iconURL"
                            :src="iconURL"
                            class="profile-icon"></img>
                        <canvas v-show="newIcon" id="icon-canvas" width="100" height="100"
                            class="profile-icon"></canvas>
                        <input type="file" @change="fileUpload($event)"/>
                        <span :class="[iconStatus]">{{ iconStatusText }}</span>
                    </div>
                </div>
                <div class="profile-row">
                    <div>Name:</div>
                    <div>
                        <input type="text" placeholder="Your nick name"
                            v-model="newName">
                        <span :class="[nameStatus]">{{ nameStatusText }}</span>
                    </div>
                </div>
                <div class="profile-row">
                    <div>Bio:</div>
                    <div>
                        <textarea class="profile-bio" placeholder="old bio"
                            v-model="newBio"></textarea>
                        <span :class="[bioStatus]">{{ bioStatusText }}</span>
                    </div>
                </div>
                <div class="button-wrapper">
                    <button class="button button-outline" @click="back">Back</button>
                    <button class="button" @click="updateProfile">Update Profile</button>
                </div>
            </div>
        </div>
        <app-footer slot="footer"></app-footer>
    </layout>
</template>

<script>
import _ from 'lodash'
import rpc from '../rpc'
import account from '../account'

import Layout from './Layout'
import Navigation from './Navigation'
import AppFooter from './Footer'

const supportedTypes = [
    "image/gif",
    "image/jpeg",
    "image/png",
    "image/svg+xml",
]

export default {
    components: { Layout, Navigation, AppFooter },
    data() {
        return {
            username: "",
            info: {},
            privInfo: {},

            oldPassword: "",
            newPassword: "",
            passwordStatus: "",
            passwordStatusText: "",

            newIcon: null,
            iconURL: null,
            iconStatus: "",
            iconStatusText: "",

            newEmail: "",
            emailStatus: "",
            emailStatusText: "",

            newName: "",
            nameStatus: "",
            nameStatusText: "",

            newBio: "",
            bioStatus: "",
            bioStatusText: "",
        }
    },
    methods: {
        fileUpload(e) {
            let file = e.target.files[0]

            if (_.includes(supportedTypes, file.type)) {
                let canvas = document.getElementById('icon-canvas')
                let reader = new FileReader()
                reader.readAsDataURL(file)

                reader.onload = () => {
                    let image = new Image()
                    image.src = reader.result

                    image.onload = () => {
                        let ctx = canvas.getContext('2d')
                        ctx.save()
                        let ratio = canvas.width / Math.min(image.width, image.height)
                        ctx.translate(canvas.width / 2, canvas.height / 2)
                        ctx.scale(ratio, ratio)
                        ctx.drawImage(image, -image.width / 2, -image.height / 2)
                        ctx.restore()
                        this.newIcon = canvas.toDataURL()
                    }
                }
            } else {
                console.log("unsupported filetype")
            }
        },
        updateProfile() {
            if (this.oldPassword !== "" && this.newPassword !== "") {
                rpc.call("/rpc/account", "change_password",
                    account.token(), this.oldPassword, this.newPassword)
                    .then(resp => {
                        if (resp.status == "ok") {
                            this.passwordStatus = "status-ok"
                            this.passwordStatusText = "Password changed successfully"
                        } else {
                            this.passwordStatus = "status-error"
                            this.passwordStatusText = resp.reason
                        }
                        this.oldPassword = ""
                        this.newPassword = ""
                    })
            }
            if (this.newEmail !== this.privInfo.email) {
                rpc.call("/rpc/account", "change_email", account.token(), this.newEmail)
                    .then(resp => {
                        if (resp.status == "ok") {
                            this.emailStatus = "status-ok"
                            this.emailStatusText = "Email changed successfully"
                            this.privInfo.email = this.newEmail
                        } else {
                            this.emailStatus  = "status-error"
                            this.emailStatusText = resp.reason
                        }
                    })
            }
            if (this.newIcon) {
                rpc.call("/rpc/account", "change_icon", account.token(), this.newIcon)
                    .then(resp => {
                        if (resp.status == "ok") {
                            this.iconStatus = "status-ok"
                            this.iconStatusText = "Icon changed successfully"
                            this.iconURL = `/archive/${resp.result}`
                            this.newIcon = null
                        } else {
                            this.iconStatus  = "status-error"
                            this.iconStatusText = resp.reason
                        }
                    })
            }
            if (this.newName !== this.info.name) {
                rpc.call("/rpc/account", "change_name", account.token(), this.newName)
                    .then(resp => {
                        if (resp.status == "ok") {
                            this.nameStatus = "status-ok"
                            this.nameStatusText = "Name changed successfully"
                            this.info.name = this.newName
                        } else {
                            this.nameStatus  = "status-error"
                            this.nameStatusText = resp.reason
                        }
                    })
            }
            if (this.newBio !== this.info.bio) {
                rpc.call("/rpc/account", "change_bio", account.token(), this.newBio)
                    .then(resp => {
                        if (resp.status == "ok") {
                            this.bioStatus = "status-ok"
                            this.bioStatusText = "Bio changed successfully"
                            this.info.bio = this.newBio
                        } else {
                            this.bioStatus  = "status-error"
                            this.bioStatusText = resp.reason
                        }
                    })
            }
        },
        back() {
            this.$router.push({name: 'User', params: { id: this.username }})
        }
    },
    mounted() {
        let uname = this.username = account.loginAs().username
        rpc.call("/rpc/account", "info", uname)
            .then(resp => {
                this.info = resp.result
                this.newName = this.info.name
                this.newBio = this.info.bio
                this.iconURL = this.info.icon ? `/archive/${this.info.icon}` : null
                console.log(this.iconURL)
            })
        rpc.call("/rpc/account", "priv_info", account.token())
            .then(resp => {
                this.privInfo = resp.result
                this.newEmail = this.privInfo.email
            })
    }
}
</script>

<style lang="less" scoped>
@import "../css/_utils.less";
@import "../css/_palatte.less";
@import "../css/_flex_helper.less";

.profile {
    .flex-row;
    width: 112.0rem;
    margin-bottom: 2rem;
}

.profile-row {
    margin-bottom: 1.2rem;
    display: flex;

    :nth-child(1) {
        width: 20rem;
    }

    :nth-child(2) {
        .flex-column;
        width: 40rem;

        * {
            margin-bottom: 0.5rem;
            width: 100%;
        }
    }

    .profile-icon {
        .square(10rem);
        border-radius: 0.3rem;
        border: 1px solid @palatte-border;
    }

    .profile-bio {
        height: 13rem;
    }
}

.button-wrapper {
    width: 100%;
    .flex-row;
    justify-content: center;

    * {
        margin: 0 0.5rem;
    }
}

.status-ok {
    color: @palatte-success;
}

.status-error {
    color: @palatte-failure;
}

.profile-wrapper {
    margin: 0 auto;
}
</style>
