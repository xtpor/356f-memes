
import _ from 'lodash'
import axios from 'axios'

function requestId() {
    return _.random(Math.pow(2, 32) - 1)
}

function sendRequest(url, method, params, id) {
    const payload = { id, method, params, jsonrpc: '2.0' }

    return axios.post(url, payload)
}

export default {
    call(url, method, ...params) {
        const id = requestId()
        return sendRequest(url, method, params, id)
            .catch(error => {
                if (error.response) {
                    // The request was made and the server responded with a status code
                    // that falls out of the range of 2xx
                    throw {message: 'InvalidResponse', code: 0, data: error.response}
                } else if (error.request) {
                    // The request was made but no response was received
                    throw {message: 'NetworkError', code: 0, data: error}
                } else {
                    // Something happened in setting up the request that triggered an Error
                    throw {message: error.name, code: 0, data: error}
                }
            })
            .then(resp => {
                let data = resp.data;

                if (data && data.jsonrpc === '2.0' && data.id === id) {
                    if (data.error) {
                        throw data.error;
                    } else {
                        return data.result;
                    }
                } else {
                    throw {message: 'InvalidResponse', code: 0, data: resp}
                }
            })
    },
    notify(url, method, ...params) {
        sendRequest(url, method, params)
    }
}
