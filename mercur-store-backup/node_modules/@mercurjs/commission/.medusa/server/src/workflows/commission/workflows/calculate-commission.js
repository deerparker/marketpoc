"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.calculateCommissionWorkflow = void 0;
const workflows_sdk_1 = require("@medusajs/workflows-sdk");
const calculate_commission_lines_1 = require("../steps/calculate-commission-lines");
const create_commission_lines_1 = require("../steps/create-commission-lines");
exports.calculateCommissionWorkflow = (0, workflows_sdk_1.createWorkflow)('calculate-commission-workflow', function (input) {
    const lines = (0, calculate_commission_lines_1.calculateCommissionLinesStep)(input);
    return new workflows_sdk_1.WorkflowResponse((0, create_commission_lines_1.createCommissionLinesStep)(lines));
});
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoiY2FsY3VsYXRlLWNvbW1pc3Npb24uanMiLCJzb3VyY2VSb290IjoiIiwic291cmNlcyI6WyIuLi8uLi8uLi8uLi8uLi8uLi9zcmMvd29ya2Zsb3dzL2NvbW1pc3Npb24vd29ya2Zsb3dzL2NhbGN1bGF0ZS1jb21taXNzaW9uLnRzIl0sIm5hbWVzIjpbXSwibWFwcGluZ3MiOiI7OztBQUFBLDJEQUEwRTtBQUUxRSxvRkFBa0Y7QUFDbEYsOEVBQTRFO0FBTy9ELFFBQUEsMkJBQTJCLEdBQUcsSUFBQSw4QkFBYyxFQUN2RCwrQkFBK0IsRUFDL0IsVUFBVSxLQUFvQjtJQUM1QixNQUFNLEtBQUssR0FBRyxJQUFBLHlEQUE0QixFQUFDLEtBQUssQ0FBQyxDQUFBO0lBRWpELE9BQU8sSUFBSSxnQ0FBZ0IsQ0FBQyxJQUFBLG1EQUF5QixFQUFDLEtBQUssQ0FBQyxDQUFDLENBQUE7QUFDL0QsQ0FBQyxDQUNGLENBQUEifQ==