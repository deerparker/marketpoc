"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.VendorUpdateOrderReturnRequest = exports.VendorGetOrderReturnRequestParams = void 0;
const zod_1 = require("zod");
const validators_1 = require("@medusajs/medusa/api/utils/validators");
exports.VendorGetOrderReturnRequestParams = (0, validators_1.createSelectParams)();
exports.VendorUpdateOrderReturnRequest = zod_1.z
    .object({
    vendor_reviewer_note: zod_1.z.string(),
    status: zod_1.z.enum(['refunded', 'withdrawn', 'escalated']),
    location_id: zod_1.z.string().optional()
})
    .strict();
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoidmFsaWRhdG9ycy5qcyIsInNvdXJjZVJvb3QiOiIiLCJzb3VyY2VzIjpbIi4uLy4uLy4uLy4uLy4uLy4uL3NyYy9hcGkvdmVuZG9yL3JldHVybi1yZXF1ZXN0L3ZhbGlkYXRvcnMudHMiXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6Ijs7O0FBQUEsNkJBQXVCO0FBRXZCLHNFQUEwRTtBQUs3RCxRQUFBLGlDQUFpQyxHQUFHLElBQUEsK0JBQWtCLEdBQUUsQ0FBQTtBQTBCeEQsUUFBQSw4QkFBOEIsR0FBRyxPQUFDO0tBQzVDLE1BQU0sQ0FBQztJQUNOLG9CQUFvQixFQUFFLE9BQUMsQ0FBQyxNQUFNLEVBQUU7SUFDaEMsTUFBTSxFQUFFLE9BQUMsQ0FBQyxJQUFJLENBQUMsQ0FBQyxVQUFVLEVBQUUsV0FBVyxFQUFFLFdBQVcsQ0FBQyxDQUFDO0lBQ3RELFdBQVcsRUFBRSxPQUFDLENBQUMsTUFBTSxFQUFFLENBQUMsUUFBUSxFQUFFO0NBQ25DLENBQUM7S0FDRCxNQUFNLEVBQUUsQ0FBQSJ9