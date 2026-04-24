"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.listOrderCommissionLinesWorkflow = void 0;
const workflows_sdk_1 = require("@medusajs/framework/workflows-sdk");
const steps_1 = require("../steps");
exports.listOrderCommissionLinesWorkflow = (0, workflows_sdk_1.createWorkflow)('list-order-commission-lines', function (input) {
    return new workflows_sdk_1.WorkflowResponse((0, steps_1.listOrderCommissionLinesStep)(input));
});
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoibGlzdC1vcmRlci1jb21taXNzaW9uLWxpbmVzLmpzIiwic291cmNlUm9vdCI6IiIsInNvdXJjZXMiOlsiLi4vLi4vLi4vLi4vLi4vLi4vc3JjL3dvcmtmbG93cy9jb21taXNzaW9uL3dvcmtmbG93cy9saXN0LW9yZGVyLWNvbW1pc3Npb24tbGluZXMudHMiXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6Ijs7O0FBQUEscUVBRzBDO0FBRTFDLG9DQUF1RDtBQUUxQyxRQUFBLGdDQUFnQyxHQUFHLElBQUEsOEJBQWMsRUFDNUQsNkJBQTZCLEVBQzdCLFVBQVUsS0FBMkI7SUFDbkMsT0FBTyxJQUFJLGdDQUFnQixDQUFDLElBQUEsb0NBQTRCLEVBQUMsS0FBSyxDQUFDLENBQUMsQ0FBQTtBQUNsRSxDQUFDLENBQ0YsQ0FBQSJ9