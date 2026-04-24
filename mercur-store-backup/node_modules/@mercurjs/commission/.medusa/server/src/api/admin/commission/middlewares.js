"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.commissionMiddlewares = void 0;
const framework_1 = require("@medusajs/framework");
const query_config_1 = require("./query-config");
const validators_1 = require("./validators");
exports.commissionMiddlewares = [
    {
        method: ['GET'],
        matcher: '/admin/commission/rules',
        middlewares: [
            (0, framework_1.validateAndTransformQuery)(validators_1.AdminCommissionRuleParams, query_config_1.adminCommissionRuleQueryConfig.list)
        ]
    },
    {
        method: ['GET'],
        matcher: '/admin/commission/commission-lines',
        middlewares: [
            (0, framework_1.validateAndTransformQuery)(validators_1.AdminGetCommissionLinesParams, query_config_1.adminCommissionLinesQueryConfig.list)
        ]
    },
    {
        method: ['POST'],
        matcher: '/admin/commission/rules',
        middlewares: [
            (0, framework_1.validateAndTransformQuery)(validators_1.AdminCommissionRuleParams, query_config_1.adminCommissionRuleQueryConfig.retrieve),
            (0, framework_1.validateAndTransformBody)(validators_1.AdminCreateCommissionRule)
        ]
    },
    {
        method: ['POST'],
        matcher: '/admin/commission/rules/:id',
        middlewares: [
            (0, framework_1.validateAndTransformQuery)(validators_1.AdminCommissionRuleParams, query_config_1.adminCommissionRuleQueryConfig.retrieve),
            (0, framework_1.validateAndTransformBody)(validators_1.AdminUpdateCommissionRule)
        ]
    },
    {
        method: ['POST'],
        matcher: '/admin/commission/default',
        middlewares: [(0, framework_1.validateAndTransformBody)(validators_1.AdminUpsertDefaultCommissionRule)]
    }
];
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoibWlkZGxld2FyZXMuanMiLCJzb3VyY2VSb290IjoiIiwic291cmNlcyI6WyIuLi8uLi8uLi8uLi8uLi8uLi9zcmMvYXBpL2FkbWluL2NvbW1pc3Npb24vbWlkZGxld2FyZXMudHMiXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6Ijs7O0FBQUEsbURBRzRCO0FBRzVCLGlEQUd1QjtBQUN2Qiw2Q0FNcUI7QUFFUixRQUFBLHFCQUFxQixHQUFzQjtJQUN0RDtRQUNFLE1BQU0sRUFBRSxDQUFDLEtBQUssQ0FBQztRQUNmLE9BQU8sRUFBRSx5QkFBeUI7UUFDbEMsV0FBVyxFQUFFO1lBQ1gsSUFBQSxxQ0FBeUIsRUFDdkIsc0NBQXlCLEVBQ3pCLDZDQUE4QixDQUFDLElBQUksQ0FDcEM7U0FDRjtLQUNGO0lBQ0Q7UUFDRSxNQUFNLEVBQUUsQ0FBQyxLQUFLLENBQUM7UUFDZixPQUFPLEVBQUUsb0NBQW9DO1FBQzdDLFdBQVcsRUFBRTtZQUNYLElBQUEscUNBQXlCLEVBQ3ZCLDBDQUE2QixFQUM3Qiw4Q0FBK0IsQ0FBQyxJQUFJLENBQ3JDO1NBQ0Y7S0FDRjtJQUNEO1FBQ0UsTUFBTSxFQUFFLENBQUMsTUFBTSxDQUFDO1FBQ2hCLE9BQU8sRUFBRSx5QkFBeUI7UUFDbEMsV0FBVyxFQUFFO1lBQ1gsSUFBQSxxQ0FBeUIsRUFDdkIsc0NBQXlCLEVBQ3pCLDZDQUE4QixDQUFDLFFBQVEsQ0FDeEM7WUFDRCxJQUFBLG9DQUF3QixFQUFDLHNDQUF5QixDQUFDO1NBQ3BEO0tBQ0Y7SUFDRDtRQUNFLE1BQU0sRUFBRSxDQUFDLE1BQU0sQ0FBQztRQUNoQixPQUFPLEVBQUUsNkJBQTZCO1FBQ3RDLFdBQVcsRUFBRTtZQUNYLElBQUEscUNBQXlCLEVBQ3ZCLHNDQUF5QixFQUN6Qiw2Q0FBOEIsQ0FBQyxRQUFRLENBQ3hDO1lBQ0QsSUFBQSxvQ0FBd0IsRUFBQyxzQ0FBeUIsQ0FBQztTQUNwRDtLQUNGO0lBQ0Q7UUFDRSxNQUFNLEVBQUUsQ0FBQyxNQUFNLENBQUM7UUFDaEIsT0FBTyxFQUFFLDJCQUEyQjtRQUNwQyxXQUFXLEVBQUUsQ0FBQyxJQUFBLG9DQUF3QixFQUFDLDZDQUFnQyxDQUFDLENBQUM7S0FDMUU7Q0FDRixDQUFBIn0=