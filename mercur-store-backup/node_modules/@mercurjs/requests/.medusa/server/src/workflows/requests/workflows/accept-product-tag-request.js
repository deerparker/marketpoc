"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.acceptProductTagRequestWorkflow = void 0;
const workflows_sdk_1 = require("@medusajs/framework/workflows-sdk");
const core_flows_1 = require("@medusajs/medusa/core-flows");
const update_request_1 = require("./update-request");
exports.acceptProductTagRequestWorkflow = (0, workflows_sdk_1.createWorkflow)('accept-product-tag-request', function (input) {
    const result = core_flows_1.createProductTagsWorkflow.runAsStep({
        input: {
            product_tags: [input.data]
        }
    });
    update_request_1.updateRequestWorkflow.runAsStep({ input });
    return new workflows_sdk_1.WorkflowResponse(result[0]);
});
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoiYWNjZXB0LXByb2R1Y3QtdGFnLXJlcXVlc3QuanMiLCJzb3VyY2VSb290IjoiIiwic291cmNlcyI6WyIuLi8uLi8uLi8uLi8uLi8uLi9zcmMvd29ya2Zsb3dzL3JlcXVlc3RzL3dvcmtmbG93cy9hY2NlcHQtcHJvZHVjdC10YWctcmVxdWVzdC50cyJdLCJuYW1lcyI6W10sIm1hcHBpbmdzIjoiOzs7QUFBQSxxRUFHMEM7QUFDMUMsNERBQXVFO0FBSXZFLHFEQUF3RDtBQUUzQyxRQUFBLCtCQUErQixHQUFHLElBQUEsOEJBQWMsRUFDM0QsNEJBQTRCLEVBQzVCLFVBQVUsS0FBdUI7SUFDL0IsTUFBTSxNQUFNLEdBQUcsc0NBQXlCLENBQUMsU0FBUyxDQUFDO1FBQ2pELEtBQUssRUFBRTtZQUNMLFlBQVksRUFBRSxDQUFDLEtBQUssQ0FBQyxJQUFJLENBQUM7U0FDM0I7S0FDRixDQUFDLENBQUE7SUFFRixzQ0FBcUIsQ0FBQyxTQUFTLENBQUMsRUFBRSxLQUFLLEVBQUUsQ0FBQyxDQUFBO0lBQzFDLE9BQU8sSUFBSSxnQ0FBZ0IsQ0FBQyxNQUFNLENBQUMsQ0FBQyxDQUFDLENBQUMsQ0FBQTtBQUN4QyxDQUFDLENBQ0YsQ0FBQSJ9