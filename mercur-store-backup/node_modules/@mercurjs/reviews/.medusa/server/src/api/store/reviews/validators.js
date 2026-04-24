"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.StoreUpdateReview = exports.StoreCreateReview = exports.StoreGetReviewsParams = void 0;
const zod_1 = require("zod");
const validators_1 = require("@medusajs/medusa/api/utils/validators");
exports.StoreGetReviewsParams = (0, validators_1.createFindParams)({
    offset: 0,
    limit: 50
});
exports.StoreCreateReview = zod_1.z.object({
    order_id: zod_1.z.string(),
    reference: zod_1.z.enum(['seller', 'product']),
    reference_id: zod_1.z.string(),
    rating: zod_1.z.number().int().min(1).max(5),
    customer_note: zod_1.z.string().max(300).nullable()
});
exports.StoreUpdateReview = zod_1.z.object({
    rating: zod_1.z.number().int().min(1).max(5),
    customer_note: zod_1.z.string().max(300).nullable()
});
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoidmFsaWRhdG9ycy5qcyIsInNvdXJjZVJvb3QiOiIiLCJzb3VyY2VzIjpbIi4uLy4uLy4uLy4uLy4uLy4uL3NyYy9hcGkvc3RvcmUvcmV2aWV3cy92YWxpZGF0b3JzLnRzIl0sIm5hbWVzIjpbXSwibWFwcGluZ3MiOiI7OztBQUFBLDZCQUF1QjtBQUV2QixzRUFBd0U7QUFHM0QsUUFBQSxxQkFBcUIsR0FBRyxJQUFBLDZCQUFnQixFQUFDO0lBQ3BELE1BQU0sRUFBRSxDQUFDO0lBQ1QsS0FBSyxFQUFFLEVBQUU7Q0FDVixDQUFDLENBQUE7QUE4QlcsUUFBQSxpQkFBaUIsR0FBRyxPQUFDLENBQUMsTUFBTSxDQUFDO0lBQ3hDLFFBQVEsRUFBRSxPQUFDLENBQUMsTUFBTSxFQUFFO0lBQ3BCLFNBQVMsRUFBRSxPQUFDLENBQUMsSUFBSSxDQUFDLENBQUMsUUFBUSxFQUFFLFNBQVMsQ0FBQyxDQUFDO0lBQ3hDLFlBQVksRUFBRSxPQUFDLENBQUMsTUFBTSxFQUFFO0lBQ3hCLE1BQU0sRUFBRSxPQUFDLENBQUMsTUFBTSxFQUFFLENBQUMsR0FBRyxFQUFFLENBQUMsR0FBRyxDQUFDLENBQUMsQ0FBQyxDQUFDLEdBQUcsQ0FBQyxDQUFDLENBQUM7SUFDdEMsYUFBYSxFQUFFLE9BQUMsQ0FBQyxNQUFNLEVBQUUsQ0FBQyxHQUFHLENBQUMsR0FBRyxDQUFDLENBQUMsUUFBUSxFQUFFO0NBQzlDLENBQUMsQ0FBQTtBQW9CVyxRQUFBLGlCQUFpQixHQUFHLE9BQUMsQ0FBQyxNQUFNLENBQUM7SUFDeEMsTUFBTSxFQUFFLE9BQUMsQ0FBQyxNQUFNLEVBQUUsQ0FBQyxHQUFHLEVBQUUsQ0FBQyxHQUFHLENBQUMsQ0FBQyxDQUFDLENBQUMsR0FBRyxDQUFDLENBQUMsQ0FBQztJQUN0QyxhQUFhLEVBQUUsT0FBQyxDQUFDLE1BQU0sRUFBRSxDQUFDLEdBQUcsQ0FBQyxHQUFHLENBQUMsQ0FBQyxRQUFRLEVBQUU7Q0FDOUMsQ0FBQyxDQUFBIn0=