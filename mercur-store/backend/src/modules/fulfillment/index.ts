import { Module } from "@medusajs/framework/utils"
import FulfillmentModuleService from "./service"

export const FULFILLMENT_MODULE = "fulfillmentModule"

export default Module(FULFILLMENT_MODULE, {
    service: FulfillmentModuleService,
})
