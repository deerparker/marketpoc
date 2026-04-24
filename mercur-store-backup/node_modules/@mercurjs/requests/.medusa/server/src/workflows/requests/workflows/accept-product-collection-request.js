"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.acceptProductCollectionRequestWorkflow = void 0;
const utils_1 = require("@medusajs/framework/utils");
const core_flows_1 = require("@medusajs/medusa/core-flows");
const workflows_sdk_1 = require("@medusajs/workflows-sdk");
const update_request_1 = require("./update-request");
exports.acceptProductCollectionRequestWorkflow = (0, workflows_sdk_1.createWorkflow)('accept-product-collection-request', function (input) {
    const collection = core_flows_1.createCollectionsWorkflow.runAsStep({
        input: {
            collections: [
                {
                    ...input.data,
                    handle: input.data.handle === ''
                        ? (0, utils_1.kebabCase)(input.data.title)
                        : input.data.handle
                }
            ]
        }
    });
    update_request_1.updateRequestWorkflow.runAsStep({ input });
    return new workflows_sdk_1.WorkflowResponse(collection[0]);
});
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoiYWNjZXB0LXByb2R1Y3QtY29sbGVjdGlvbi1yZXF1ZXN0LmpzIiwic291cmNlUm9vdCI6IiIsInNvdXJjZXMiOlsiLi4vLi4vLi4vLi4vLi4vLi4vc3JjL3dvcmtmbG93cy9yZXF1ZXN0cy93b3JrZmxvd3MvYWNjZXB0LXByb2R1Y3QtY29sbGVjdGlvbi1yZXF1ZXN0LnRzIl0sIm5hbWVzIjpbXSwibWFwcGluZ3MiOiI7OztBQUFBLHFEQUFxRDtBQUNyRCw0REFBdUU7QUFDdkUsMkRBQTBFO0FBSTFFLHFEQUF3RDtBQUUzQyxRQUFBLHNDQUFzQyxHQUFHLElBQUEsOEJBQWMsRUFDbEUsbUNBQW1DLEVBQ25DLFVBQVUsS0FBdUI7SUFDL0IsTUFBTSxVQUFVLEdBQUcsc0NBQXlCLENBQUMsU0FBUyxDQUFDO1FBQ3JELEtBQUssRUFBRTtZQUNMLFdBQVcsRUFBRTtnQkFDWDtvQkFDRSxHQUFHLEtBQUssQ0FBQyxJQUFJO29CQUNiLE1BQU0sRUFDSixLQUFLLENBQUMsSUFBSSxDQUFDLE1BQU0sS0FBSyxFQUFFO3dCQUN0QixDQUFDLENBQUMsSUFBQSxpQkFBUyxFQUFDLEtBQUssQ0FBQyxJQUFJLENBQUMsS0FBSyxDQUFDO3dCQUM3QixDQUFDLENBQUMsS0FBSyxDQUFDLElBQUksQ0FBQyxNQUFNO2lCQUN4QjthQUNGO1NBQ0Y7S0FDRixDQUFDLENBQUE7SUFFRixzQ0FBcUIsQ0FBQyxTQUFTLENBQUMsRUFBRSxLQUFLLEVBQUUsQ0FBQyxDQUFBO0lBQzFDLE9BQU8sSUFBSSxnQ0FBZ0IsQ0FBQyxVQUFVLENBQUMsQ0FBQyxDQUFDLENBQUMsQ0FBQTtBQUM1QyxDQUFDLENBQ0YsQ0FBQSJ9