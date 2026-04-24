"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.vendorCommissionMiddlewares = void 0;
const framework_1 = require("@medusajs/framework");
const query_config_1 = require("./query-config");
const validators_1 = require("./validators");
exports.vendorCommissionMiddlewares = [
    {
        method: ['GET'],
        matcher: '/vendor/commission',
        middlewares: [
            (0, framework_1.validateAndTransformQuery)(validators_1.VendorGetCommissionLinesParams, query_config_1.vendorCommissionLinesQueryConfig.list)
        ]
    }
];
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoibWlkZGxld2FyZXMuanMiLCJzb3VyY2VSb290IjoiIiwic291cmNlcyI6WyIuLi8uLi8uLi8uLi8uLi8uLi9zcmMvYXBpL3ZlbmRvci9jb21taXNzaW9uL21pZGRsZXdhcmVzLnRzIl0sIm5hbWVzIjpbXSwibWFwcGluZ3MiOiI7OztBQUFBLG1EQUFnRjtBQUVoRixpREFBaUU7QUFDakUsNkNBQTZEO0FBRWhELFFBQUEsMkJBQTJCLEdBQXNCO0lBQzVEO1FBQ0UsTUFBTSxFQUFFLENBQUMsS0FBSyxDQUFDO1FBQ2YsT0FBTyxFQUFFLG9CQUFvQjtRQUM3QixXQUFXLEVBQUU7WUFDWCxJQUFBLHFDQUF5QixFQUN2QiwyQ0FBOEIsRUFDOUIsK0NBQWdDLENBQUMsSUFBSSxDQUN0QztTQUNGO0tBQ0Y7Q0FDRixDQUFBIn0=