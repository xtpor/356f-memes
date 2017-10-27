import moment from 'moment'

export function formatFromNow(dateString) {
    return moment(dateString).fromNow()
}

export function formatDate(utcDate) {
    let p2 = t => ("00" + t).slice(-2)
    let d = new Date(utcDate)
    let [dd, mm, yyyy] = [p2(d.getDate()), p2(d.getMonth() + 1), d.getFullYear()]
    return `${dd}/${mm}/${yyyy}`
}

export function imageURL(archive) {
    return `/archive/${archive}`
}
