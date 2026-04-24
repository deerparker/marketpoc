import { ExecArgs } from '@medusajs/framework/types'
import { ContainerRegistrationKeys, Modules } from '@medusajs/framework/utils'

export default async function spyProductModule({ container }: ExecArgs) {
    const logger = container.resolve(ContainerRegistrationKeys.LOGGER)
    const productModule = container.resolve(Modules.PRODUCT)

    logger.info('Inspecting Product Module...')

    // Log all properties (functions)
    const props = []
    let obj = productModule
    while (obj) {
        props.push(...Object.getOwnPropertyNames(obj))
        obj = Object.getPrototypeOf(obj)
    }

    logger.info(`Methods: ${props.sort().join(', ')}`)
}
