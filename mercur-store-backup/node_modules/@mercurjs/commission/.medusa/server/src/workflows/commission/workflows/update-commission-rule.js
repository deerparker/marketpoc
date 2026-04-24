"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.updateCommissionRuleWorkflow = void 0;
const workflows_sdk_1 = require("@medusajs/workflows-sdk");
const steps_1 = require("../steps");
exports.updateCommissionRuleWorkflow = (0, workflows_sdk_1.createWorkflow)('update-commission-rule', function (input) {
    return new workflows_sdk_1.WorkflowResponse((0, steps_1.updateCommissionRuleStep)(input));
});
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoidXBkYXRlLWNvbW1pc3Npb24tcnVsZS5qcyIsInNvdXJjZVJvb3QiOiIiLCJzb3VyY2VzIjpbIi4uLy4uLy4uLy4uLy4uLy4uL3NyYy93b3JrZmxvd3MvY29tbWlzc2lvbi93b3JrZmxvd3MvdXBkYXRlLWNvbW1pc3Npb24tcnVsZS50cyJdLCJuYW1lcyI6W10sIm1hcHBpbmdzIjoiOzs7QUFBQSwyREFBMEU7QUFJMUUsb0NBQW1EO0FBRXRDLFFBQUEsNEJBQTRCLEdBQUcsSUFBQSw4QkFBYyxFQUN4RCx3QkFBd0IsRUFDeEIsVUFBVSxLQUE4QjtJQUN0QyxPQUFPLElBQUksZ0NBQWdCLENBQUMsSUFBQSxnQ0FBd0IsRUFBQyxLQUFLLENBQUMsQ0FBQyxDQUFBO0FBQzlELENBQUMsQ0FDRixDQUFBIn0=