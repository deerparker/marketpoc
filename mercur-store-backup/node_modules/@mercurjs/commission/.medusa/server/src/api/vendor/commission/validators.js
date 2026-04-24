"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.VendorGetCommissionLinesParams = void 0;
const zod_1 = require("zod");
const validators_1 = require("@medusajs/medusa/api/utils/validators");
exports.VendorGetCommissionLinesParams = (0, validators_1.createFindParams)({
    limit: 15,
    offset: 0
}).merge(zod_1.z.object({
    start_date: zod_1.z.coerce.date().optional(),
    end_date: zod_1.z.coerce.date().optional()
}));
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoidmFsaWRhdG9ycy5qcyIsInNvdXJjZVJvb3QiOiIiLCJzb3VyY2VzIjpbIi4uLy4uLy4uLy4uLy4uLy4uL3NyYy9hcGkvdmVuZG9yL2NvbW1pc3Npb24vdmFsaWRhdG9ycy50cyJdLCJuYW1lcyI6W10sIm1hcHBpbmdzIjoiOzs7QUFBQSw2QkFBdUI7QUFFdkIsc0VBQXdFO0FBRTNELFFBQUEsOEJBQThCLEdBQUcsSUFBQSw2QkFBZ0IsRUFBQztJQUM3RCxLQUFLLEVBQUUsRUFBRTtJQUNULE1BQU0sRUFBRSxDQUFDO0NBQ1YsQ0FBQyxDQUFDLEtBQUssQ0FDTixPQUFDLENBQUMsTUFBTSxDQUFDO0lBQ1AsVUFBVSxFQUFFLE9BQUMsQ0FBQyxNQUFNLENBQUMsSUFBSSxFQUFFLENBQUMsUUFBUSxFQUFFO0lBQ3RDLFFBQVEsRUFBRSxPQUFDLENBQUMsTUFBTSxDQUFDLElBQUksRUFBRSxDQUFDLFFBQVEsRUFBRTtDQUNyQyxDQUFDLENBQ0gsQ0FBQSJ9