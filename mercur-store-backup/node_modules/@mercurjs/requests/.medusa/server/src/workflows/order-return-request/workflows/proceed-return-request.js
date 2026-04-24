"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.proceedReturnRequestWorkflow = void 0;
const workflows_sdk_1 = require("@medusajs/framework/workflows-sdk");
const core_flows_1 = require("@medusajs/medusa/core-flows");
const steps_1 = require("../steps");
exports.proceedReturnRequestWorkflow = (0, workflows_sdk_1.createWorkflow)('proceed-return-request', function (input) {
    const order = (0, steps_1.retrieveOrderFromReturnRequestStep)(input);
    const beginPayload = (0, workflows_sdk_1.transform)({ order, input }, ({ order, input }) => {
        return {
            input: {
                order_id: order.order_id,
                location_id: input.location_id
            }
        };
    });
    const returnOrder = core_flows_1.beginReturnOrderWorkflow.runAsStep(beginPayload);
    const requestItemReturnPayload = (0, workflows_sdk_1.transform)({ returnOrder, order }, ({ returnOrder, order }) => {
        return {
            input: {
                return_id: returnOrder.return_id,
                items: order.order_return_request.line_items.map((item) => {
                    return {
                        id: item.line_item_id,
                        quantity: item.quantity,
                        reason_id: item.reason_id
                    };
                })
            }
        };
    });
    core_flows_1.requestItemReturnWorkflow.runAsStep(requestItemReturnPayload);
    const confirmReturnRequestPayload = (0, workflows_sdk_1.transform)(returnOrder, (returnOrder) => {
        return {
            input: {
                return_id: returnOrder.return_id
            }
        };
    });
    core_flows_1.confirmReturnRequestWorkflow.runAsStep(confirmReturnRequestPayload);
    return new workflows_sdk_1.WorkflowResponse(returnOrder);
});
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoicHJvY2VlZC1yZXR1cm4tcmVxdWVzdC5qcyIsInNvdXJjZVJvb3QiOiIiLCJzb3VyY2VzIjpbIi4uLy4uLy4uLy4uLy4uLy4uL3NyYy93b3JrZmxvd3Mvb3JkZXItcmV0dXJuLXJlcXVlc3Qvd29ya2Zsb3dzL3Byb2NlZWQtcmV0dXJuLXJlcXVlc3QudHMiXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6Ijs7O0FBQUEscUVBSTBDO0FBQzFDLDREQUlvQztBQU9wQyxvQ0FBNkQ7QUFFaEQsUUFBQSw0QkFBNEIsR0FBRyxJQUFBLDhCQUFjLEVBQ3hELHdCQUF3QixFQUN4QixVQUNFLEtBQTJFO0lBRTNFLE1BQU0sS0FBSyxHQUFHLElBQUEsMENBQWtDLEVBQUMsS0FBSyxDQUFDLENBQUE7SUFDdkQsTUFBTSxZQUFZLEdBQUcsSUFBQSx5QkFBUyxFQUFDLEVBQUUsS0FBSyxFQUFFLEtBQUssRUFBRSxFQUFFLENBQUMsRUFBRSxLQUFLLEVBQUUsS0FBSyxFQUFFLEVBQUUsRUFBRTtRQUNwRSxPQUFPO1lBQ0wsS0FBSyxFQUFFO2dCQUNMLFFBQVEsRUFBRSxLQUFLLENBQUMsUUFBUTtnQkFDeEIsV0FBVyxFQUFFLEtBQUssQ0FBQyxXQUFXO2FBQy9CO1NBQ0YsQ0FBQTtJQUNILENBQUMsQ0FBQyxDQUFBO0lBRUYsTUFBTSxXQUFXLEdBQUcscUNBQXdCLENBQUMsU0FBUyxDQUFDLFlBQVksQ0FBQyxDQUFBO0lBRXBFLE1BQU0sd0JBQXdCLEdBQUcsSUFBQSx5QkFBUyxFQUN4QyxFQUFFLFdBQVcsRUFBRSxLQUFLLEVBQUUsRUFDdEIsQ0FBQyxFQUFFLFdBQVcsRUFBRSxLQUFLLEVBQUUsRUFBRSxFQUFFO1FBQ3pCLE9BQU87WUFDTCxLQUFLLEVBQUU7Z0JBQ0wsU0FBUyxFQUFFLFdBQVcsQ0FBQyxTQUFTO2dCQUNoQyxLQUFLLEVBQUUsS0FBSyxDQUFDLG9CQUFvQixDQUFDLFVBQVUsQ0FBQyxHQUFHLENBQUMsQ0FBQyxJQUFJLEVBQUUsRUFBRTtvQkFDeEQsT0FBTzt3QkFDTCxFQUFFLEVBQUUsSUFBSSxDQUFDLFlBQVk7d0JBQ3JCLFFBQVEsRUFBRSxJQUFJLENBQUMsUUFBUTt3QkFDdkIsU0FBUyxFQUFFLElBQUksQ0FBQyxTQUFTO3FCQUMxQixDQUFBO2dCQUNILENBQUMsQ0FBQzthQUNIO1NBQ0YsQ0FBQTtJQUNILENBQUMsQ0FDRixDQUFBO0lBRUQsc0NBQXlCLENBQUMsU0FBUyxDQUFDLHdCQUF3QixDQUFDLENBQUE7SUFFN0QsTUFBTSwyQkFBMkIsR0FBRyxJQUFBLHlCQUFTLEVBQzNDLFdBQVcsRUFDWCxDQUFDLFdBQVcsRUFBRSxFQUFFO1FBQ2QsT0FBTztZQUNMLEtBQUssRUFBRTtnQkFDTCxTQUFTLEVBQUUsV0FBVyxDQUFDLFNBQVM7YUFDakM7U0FDRixDQUFBO0lBQ0gsQ0FBQyxDQUNGLENBQUE7SUFFRCx5Q0FBNEIsQ0FBQyxTQUFTLENBQUMsMkJBQTJCLENBQUMsQ0FBQTtJQUVuRSxPQUFPLElBQUksZ0NBQWdCLENBQUMsV0FBVyxDQUFDLENBQUE7QUFDMUMsQ0FBQyxDQUNGLENBQUEifQ==