import * as Knex from 'knex'

type Bit = 0 | 1

interface GetResponse {
    reply: string
}
interface DeleteResponse {
    reply: number
}
interface SetResponse {
    reply: Bit
}

export async function del(knex: Knex, key: string) {
    const sql = 'exec KeyValue_DEL @key=:key'
    const qb = knex.raw<DeleteResponse[]>(sql, { key })
    const [row] = await qb
    return row.reply
}
export async function get(knex: Knex, key: string) {
    const sql = 'exec KeyValue_GET @key=:key'
    const qb = knex.raw<GetResponse[]>(sql, { key })
    const [row] = await qb
    return row.reply
}

export interface SetOptions {
    ex?: number,
    nx?: boolean | Bit,
}
export async function set(knex: Knex, key: string, value: string, options: SetOptions = {}) {
    const { ex, nx } = options

    const params = ['@key=:key', '@value=:value']
    ex && params.push('@ex=:ex')
    nx && params.push('@nx=:nx')

    let sql = 'exec KeyValue_SET ' + params.join(',')

    const qb = knex.raw<SetResponse[]>(sql, {
        key,
        value,
        ex, nx
    })
    const [row] = await qb
    return row.reply === 1
}
