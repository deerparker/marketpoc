"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.acceptProductTypeRequestWorkflow = void 0;
const workflows_sdk_1 = require("@medusajs/framework/workflows-sdk");
const core_flows_1 = require("@medusajs/medusa/core-flows");
const update_request_1 = require("./update-request");
exports.acceptProductTypeRequestWorkflow = (0, workflows_sdk_1.createWorkflow)('accept-product-type-request', function (input) {
    const result = core_flows_1.createProductTypesWorkflow.runAsStep({
        input: {
            product_types: [input.data]
        }
    });
    update_request_1.updateRequestWorkflow.runAsStep({ input });
    return new workflows_sdk_1.WorkflowResponse(result[0]);
});
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoiYWNjZXB0LXByb2R1Y3QtdHlwZS1yZXF1ZXN0LmpzIiwic291cmNlUm9vdCI6IiIsInNvdXJjZXMiOlsiLi4vLi4vLi4vLi4vLi4vLi4vc3JjL3dvcmtmbG93cy9yZXF1ZXN0cy93b3JrZmxvd3MvYWNjZXB0LXByb2R1Y3QtdHlwZS1yZXF1ZXN0LnRzIl0sIm5hbWVzIjpbXSwibWFwcGluZ3MiOiI7OztBQUFBLHFFQUcwQztBQUMxQyw0REFBd0U7QUFJeEUscURBQXdEO0FBRTNDLFFBQUEsZ0NBQWdDLEdBQUcsSUFBQSw4QkFBYyxFQUM1RCw2QkFBNkIsRUFDN0IsVUFBVSxLQUF1QjtJQUMvQixNQUFNLE1BQU0sR0FBRyx1Q0FBMEIsQ0FBQyxTQUFTLENBQUM7UUFDbEQsS0FBSyxFQUFFO1lBQ0wsYUFBYSxFQUFFLENBQUMsS0FBSyxDQUFDLElBQUksQ0FBQztTQUM1QjtLQUNGLENBQUMsQ0FBQTtJQUVGLHNDQUFxQixDQUFDLFNBQVMsQ0FBQyxFQUFFLEtBQUssRUFBRSxDQUFDLENBQUE7SUFDMUMsT0FBTyxJQUFJLGdDQUFnQixDQUFDLE1BQU0sQ0FBQyxDQUFDLENBQUMsQ0FBQyxDQUFBO0FBQ3hDLENBQUMsQ0FDRixDQUFBIn0=