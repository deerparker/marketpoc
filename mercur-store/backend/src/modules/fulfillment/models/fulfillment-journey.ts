import { model } from "@medusajs/framework/utils"

export const FulfillmentJourney = model.define("fulfillment_journey", {
    id: model.id().primaryKey(),
    type: model.enum(["shopify", "form", "voucher", "whatsapp", "manual"]).default("manual"),
    config: model.json().nullable(),
    seller_id: model.text().searchable(),
})
