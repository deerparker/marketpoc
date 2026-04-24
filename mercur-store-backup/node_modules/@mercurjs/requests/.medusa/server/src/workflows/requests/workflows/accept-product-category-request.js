"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.acceptProductCategoryRequestWorkflow = void 0;
const utils_1 = require("@medusajs/framework/utils");
const core_flows_1 = require("@medusajs/medusa/core-flows");
const workflows_sdk_1 = require("@medusajs/workflows-sdk");
const update_request_1 = require("./update-request");
exports.acceptProductCategoryRequestWorkflow = (0, workflows_sdk_1.createWorkflow)('accept-product-category-request', function (input) {
    const productCategory = core_flows_1.createProductCategoriesWorkflow.runAsStep({
        input: {
            product_categories: [
                {
                    ...input.data,
                    handle: input.data.handle === ''
                        ? (0, utils_1.kebabCase)(input.data.name)
                        : input.data.handle,
                    is_active: true
                }
            ]
        }
    });
    update_request_1.updateRequestWorkflow.runAsStep({ input });
    return new workflows_sdk_1.WorkflowResponse(productCategory[0]);
});
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoiYWNjZXB0LXByb2R1Y3QtY2F0ZWdvcnktcmVxdWVzdC5qcyIsInNvdXJjZVJvb3QiOiIiLCJzb3VyY2VzIjpbIi4uLy4uLy4uLy4uLy4uLy4uL3NyYy93b3JrZmxvd3MvcmVxdWVzdHMvd29ya2Zsb3dzL2FjY2VwdC1wcm9kdWN0LWNhdGVnb3J5LXJlcXVlc3QudHMiXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6Ijs7O0FBQUEscURBQXFEO0FBQ3JELDREQUE2RTtBQUM3RSwyREFBMEU7QUFJMUUscURBQXdEO0FBRTNDLFFBQUEsb0NBQW9DLEdBQUcsSUFBQSw4QkFBYyxFQUNoRSxpQ0FBaUMsRUFDakMsVUFBVSxLQUF1QjtJQUMvQixNQUFNLGVBQWUsR0FBRyw0Q0FBK0IsQ0FBQyxTQUFTLENBQUM7UUFDaEUsS0FBSyxFQUFFO1lBQ0wsa0JBQWtCLEVBQUU7Z0JBQ2xCO29CQUNFLEdBQUcsS0FBSyxDQUFDLElBQUk7b0JBQ2IsTUFBTSxFQUNKLEtBQUssQ0FBQyxJQUFJLENBQUMsTUFBTSxLQUFLLEVBQUU7d0JBQ3RCLENBQUMsQ0FBQyxJQUFBLGlCQUFTLEVBQUMsS0FBSyxDQUFDLElBQUksQ0FBQyxJQUFJLENBQUM7d0JBQzVCLENBQUMsQ0FBQyxLQUFLLENBQUMsSUFBSSxDQUFDLE1BQU07b0JBQ3ZCLFNBQVMsRUFBRSxJQUFJO2lCQUNoQjthQUNGO1NBQ0Y7S0FDRixDQUFDLENBQUE7SUFFRixzQ0FBcUIsQ0FBQyxTQUFTLENBQUMsRUFBRSxLQUFLLEVBQUUsQ0FBQyxDQUFBO0lBQzFDLE9BQU8sSUFBSSxnQ0FBZ0IsQ0FBQyxlQUFlLENBQUMsQ0FBQyxDQUFDLENBQUMsQ0FBQTtBQUNqRCxDQUFDLENBQ0YsQ0FBQSJ9