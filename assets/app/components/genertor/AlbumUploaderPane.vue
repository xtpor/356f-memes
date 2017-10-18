<template lang="html">
    <layout class="album-uploader-pane">
        <trail :items="['Generator', 'Pick from album']"
           slot="trail"  @back="$emit('back')"/>

        <input class="search-bar" type="text" placeholder="Search by keywords" v-model="search"/>
        <div class="item-container">
            <div class="item" v-for="(item, index) in items" @click="click(index)">
                <div class="item-image">
                    <i v-if="!item.loaded"
                       class="fa fa-spinner fa-pulse fa-3x fa-fw"></i>
                    <img v-if="item.loaded" class="inner-image"
                    :src="item.url"></img>
                </div>
                <div class="item-text">{{ item.name }}</div>
            </div>
        </div>
        <div class="control-box">
            <button class="button" @click="prevPage">
                <i class="fa fa-angle-left fa-2x" aria-hidden="true"></i>
            </button>
            <span class="page-number">Page {{ page + 1 }}</span>
            <button class="button" @click="nextPage">
                <i class="fa fa-angle-right fa-2x" aria-hidden="true"></i>
            </button>
        </div>
    </layout>
</template>

<script>
import _ from 'lodash'
import stringSimilarity from 'string-similarity'
import rpc from '../../rpc'

import Layout from './Layout'
import Trail from '../widgets/Trail'

function formatURL(hash) {
    let loc = window.location
    return `${loc.protocol}//${loc.host}/archive/${hash}`
}

export default {
    components: { Layout, Trail },
    data() {
        return {
            page: 0,
            names: [],
            cache: {},
            items: [],
            search: ""
        }
    },
    methods: {
        update() {
            this.items = _.map(this.pageNames(), name => {
                let hash = this.cache[name]
                if (hash) {
                    return {name, url: formatURL(hash), loaded: true}
                } else {
                    return {name, loaded: false}
                }
            });
        },
        nextPage() {
            console.log('pressed next page')
            if ((this.page + 1) * 10 < this.names.length) {
                this.page += 1
                this.update()
            }
        },
        prevPage() {
            if (this.page > 0) {
                this.page -= 1
                this.update()
            }
        },
        pageNames() {
            return this.names.slice(this.page * 10, this.page * 10 + 10)
        },
        click(index) {
            let url = formatURL(this.cache[this.pageNames()[index]])
            rpc.call("/rpc", "fetch", url)
                .then(resp => {
                    window.storage.rawImageData = resp.data
                    this.$emit("done")
                })
        },
        performSearch: _.debounce(function (text) {
            if (text == '') return;

            let names = _.sortBy(this.names, function (name) {
                return 1 - stringSimilarity.compareTwoStrings(text, name);
            });

            this.names = names;
            this.page = 0;
            this.update();
        }, 1000),
    },
    watch: {
        search() {
            return this.performSearch(this.search)
        }
    },
    mounted() {
        rpc.call("/rpc/template", "list")
            .then(list => {
                console.log('fetched all the template names')
                _.each(list, ({name, hash}) => {
                    this.names.push(name)
                    this.cache[name] = hash
                })

                this.update()
            })
    }
}
</script>

<style lang="less" scoped>
@import "../../css/_palatte.less";
@import "../../css/_flex_helper.less";

.album-uploader-pane {

    .search-bar {
        margin-bottom: 2rem;
        width: 80rem;
    }

    .item-container {
        .flex-row;
        flex-wrap: wrap;
        justify-content: center;

        padding: 0 12rem;
        height: 30.5rem;
    }

    .item {
        .flex-column;
        align-items: center;
        width: 17.5rem;
        height: 15rem;

        .item-image {
            border: 1px solid @palatte-primary;
            border-radius: 0.3rem;
            width: 10rem;
            height: 10rem;

            .flex-center;
            i {
                width: 5rem;
                height: 5rem;
            }

            .inner-image {
                width: 100%;
                height: 100%;
                background-position: center center;
                background-repeat: no-repeat;
                object-fit: cover;
                object-position: center;
            }
        }

        .item-text {
            font-size: 1.5rem;
            word-wrap: break-word;
            text-align: center;
        }
    }

    .item:hover {
        cursor: pointer;

        .item-image {
            border: 1px solid @palatte-secondary;
        }

        .item-text {
            color: @palatte-secondary;
        }
    }

    .control-box {
        .flex-row;
        margin-top: 0.8rem;

        .button {
            .flex-center;
            padding: 0;
            margin: 0 0.5rem;
            width: 3.8rem;

        }

        .page-number {
            margin: 0 0.8rem;
            width: 7rem;
            line-height: 3.8rem;
            vertical-align: middle;
            text-align: center;
        }
    }

}
</style>
