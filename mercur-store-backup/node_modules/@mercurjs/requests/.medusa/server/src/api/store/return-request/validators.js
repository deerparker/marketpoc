"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.StoreCreateReturnRequest = exports.StoreGetOrderReturnRequestParams = void 0;
const zod_1 = require("zod");
const validators_1 = require("@medusajs/medusa/api/utils/validators");
exports.StoreGetOrderReturnRequestParams = (0, validators_1.createFindParams)({
    offset: 0,
    limit: 50
});
exports.StoreCreateReturnRequest = zod_1.z
    .object({
    order_id: zod_1.z.string(),
    shipping_option_id: zod_1.z.string().optional(),
    line_items: zod_1.z.array(zod_1.z.object({
        line_item_id: zod_1.z.string(),
        quantity: zod_1.z.number(),
        reason_id: zod_1.z.string().optional()
    })),
    customer_note: zod_1.z.string()
})
    .strict();
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoidmFsaWRhdG9ycy5qcyIsInNvdXJjZVJvb3QiOiIiLCJzb3VyY2VzIjpbIi4uLy4uLy4uLy4uLy4uLy4uL3NyYy9hcGkvc3RvcmUvcmV0dXJuLXJlcXVlc3QvdmFsaWRhdG9ycy50cyJdLCJuYW1lcyI6W10sIm1hcHBpbmdzIjoiOzs7QUFBQSw2QkFBdUI7QUFFdkIsc0VBQXdFO0FBSzNELFFBQUEsZ0NBQWdDLEdBQUcsSUFBQSw2QkFBZ0IsRUFBQztJQUMvRCxNQUFNLEVBQUUsQ0FBQztJQUNULEtBQUssRUFBRSxFQUFFO0NBQ1YsQ0FBQyxDQUFBO0FBbUNXLFFBQUEsd0JBQXdCLEdBQUcsT0FBQztLQUN0QyxNQUFNLENBQUM7SUFDTixRQUFRLEVBQUUsT0FBQyxDQUFDLE1BQU0sRUFBRTtJQUNwQixrQkFBa0IsRUFBRSxPQUFDLENBQUMsTUFBTSxFQUFFLENBQUMsUUFBUSxFQUFFO0lBQ3pDLFVBQVUsRUFBRSxPQUFDLENBQUMsS0FBSyxDQUNqQixPQUFDLENBQUMsTUFBTSxDQUFDO1FBQ1AsWUFBWSxFQUFFLE9BQUMsQ0FBQyxNQUFNLEVBQUU7UUFDeEIsUUFBUSxFQUFFLE9BQUMsQ0FBQyxNQUFNLEVBQUU7UUFDcEIsU0FBUyxFQUFFLE9BQUMsQ0FBQyxNQUFNLEVBQUUsQ0FBQyxRQUFRLEVBQUU7S0FDakMsQ0FBQyxDQUNIO0lBQ0QsYUFBYSxFQUFFLE9BQUMsQ0FBQyxNQUFNLEVBQUU7Q0FDMUIsQ0FBQztLQUNELE1BQU0sRUFBRSxDQUFBIn0=