import { ExecArgs } from '@medusajs/framework/types'
import { ContainerRegistrationKeys, Modules } from '@medusajs/framework/utils'

export default async function countProducts({ container }: ExecArgs) {
    const logger = container.resolve(ContainerRegistrationKeys.LOGGER)
    const productModule = container.resolve(Modules.PRODUCT) as any

    const [products, count] = await productModule.listAndCountProducts({}, { select: ['id'] })
    logger.info(`Total products in database: ${count}`)
}
