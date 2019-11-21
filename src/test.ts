import * as Knex from 'knex'
import * as KV from './index'
import KeyValue from './KeyValue'

const knex = Knex({ client: 'mssql' })

async function testGet() {
    const qb = KV.get(knex, 'ACT:UpdateInterval')
    console.log(qb.toString())
}
async function testSet() {
    const res0 = await KV.set(knex, 'ACT:UpdateInterval', '30')
    console.log(res0)

    const res1 = await KV.set(knex, 'ACT:UpdateInterval', '30', {
        ex: 10, nx: 1
    })
    console.log(res1)
}

async function testKeyValue() {
    const kv = new KeyValue(knex)
    await kv.set('ACT:UpdateInterval', '30')
    const ui = await kv.get('ACT:UpdateInterval')
    if (ui !== '30') throw new Error
}

async function main() {
    await testKeyValue()
}

main().catch(err => {
    console.error(err)
})
