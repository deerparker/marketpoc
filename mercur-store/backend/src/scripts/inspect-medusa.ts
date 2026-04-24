import { ExecArgs } from '@medusajs/framework/types'
import { ContainerRegistrationKeys, Modules } from '@medusajs/framework/utils'

export default async function inspectMedusa({ container }: ExecArgs) {
    const logger = container.resolve(ContainerRegistrationKeys.LOGGER)
    const authService = container.resolve(Modules.AUTH)

    logger.info('Listing IDs...')
    try {
        // @ts-ignore
        const ids = await authService.listAuthIdentities({})
        logger.info(JSON.stringify(ids, null, 2))
    } catch (e) {
        logger.error(e)
    }
}
