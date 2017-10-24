
import rpc from './rpc'

const key = 'loginAs'

export default {
    token() {
        return sessionStorage.getItem(key) || localStorage.getItem(key)
    },
    loginAs() {
        let loginAs = this.token()
        if (loginAs) {
            return JSON.parse(atob(loginAs.split('.')[1]))
        } else {
            return null
        }
    },
    logout() {
        sessionStorage.removeItem(key)
        localStorage.removeItem(key)
    },
    login(username, password, rememberMe) {
        this.logout()
        return rpc.call('/rpc/account', 'login', username, password)
            .then(resp => {
                if (resp.status === 'ok') {
                    let storage = rememberMe ? localStorage : sessionStorage
                    storage.setItem(key, resp.result)
                }
                return resp
            })
    }
}
