import * as Knex from 'knex'
import * as KV from './lib'

export default class KeyValue {
    knex: Knex
    del(key: string) {
        return KV.del(this.knex, key)
    }
    get(key: string) {
        return KV.get(this.knex, key)
    }
    set(key: string, value: string, options: KV.SetOptions = {}) {
        return KV.set(this.knex, key, value, options)
    }
    constructor(knex: Knex) {
        this.knex = knex
    }
}
