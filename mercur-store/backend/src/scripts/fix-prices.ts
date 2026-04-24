import { ExecArgs } from '@medusajs/framework/types'
import { ContainerRegistrationKeys, Modules } from '@medusajs/framework/utils'

// Imports likely needed for EntityManager
import { EntityManager } from '@mikro-orm/core'

export default async function fixPrices({ container }: ExecArgs) {
    const logger = container.resolve(ContainerRegistrationKeys.LOGGER)
    const manager = container.resolve("manager") as any

    logger.info('Fixing Product Prices via Raw SQL...')

    try {
        // 1. Check if 'price' table exists and has data
        // Medusa 2.0 uses Pricing Module. Table might be 'price' or 'money_amount' (legacy).
        // Let's try 'price' first which is standard for Pricing Module.

        const check = await manager.execute("SELECT count(*) FROM information_schema.tables WHERE table_name = 'price'")
        const isPriceTable = check[0].count > 0

        const tableName = isPriceTable ? 'price' : 'money_amount'
        logger.info(`Detected pricing table: ${tableName}`)

        // 2. Run Update
        // Update amounts < 1000 (10.00) by multiplying by 100
        const result = await manager.execute(`
            UPDATE ${tableName} 
            SET amount = amount * 100 
            WHERE amount < 1000 
            AND amount > 0
        `)

        logger.info(`Updated prices. Affected rows: ${result.rowCount || result.affectedRows || 'unknown'}`)

    } catch (e) {
        logger.error('Error executing raw SQL:', e)
    }

    logger.info('Price fix completed.')
}
